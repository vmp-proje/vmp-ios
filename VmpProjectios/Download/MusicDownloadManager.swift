//
//  MusicDownloadManager.swift
//  VmpProjectios
//
//  Created by Anil Joe on 12.04.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import UIKit


/**
 Singleton Class  used by BaseMusicPlayerVieewController:
 Download - Remove Downloaded Content - Checks whether file has downloaded
 */
class MusicDownloadManager: NSObject, URLSessionDownloadDelegate {
  
  
  //MARK: - Constants
  static let shared = MusicDownloadManager()
  
  
  //MARK: - Variables
  var urlSession: URLSession?
  var task: URLSessionDownloadTask?
  var activeDownloads: [URL: Download] = [:]
  var currentDownload: Download? {
    if let currentURL = currentURL {
      return activeDownloads[currentURL]
    }
    return nil
  }
  
  let dispatch = DispatchGroup()
  
  var currentDownloadState: DownloadState? {
    guard let url = self.currentURL else {return nil}
    return self.activeDownloads[url]?.state
  }
  
  var currentURL: URL?
  var dispatchQueue = DispatchQueue(label: "")
  
  var downloadDelegate: DownloadButtonProtocol?
  var playlistDownloadDelegate: DownloadButtonProtocol?
  ///Document folder url
  var documentsDirectoryURL: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  }
  
  
  //MARK: - Functions
  func prepare(queue: [CategoryContentListData]) {
    
    for content in queue {
      if let url = getAPIUrl(link: content.attributes?.media) {
        activeDownloads[url] = Download(content: content)
      }
    }
    
//    AppNotification.shared.updatePlaylistCollectionView()
    
    for content in queue {
      dispatchQueue.async {
        if let url = self.getAPIUrl(link: content.attributes?.media) {
          self.currentURL = url
          let localUrl = self.getLocalURL(url: url, id: content.id!)
          if !self.isDownloaded(url: localUrl) {
            print("\n\n\n 🌈🌈🌈🌈🌈🌈🌈🌈 downloading: \(String(describing: content.attributes?.name!))")
            self.download(url: url)
          } else {
            print("💔💔💔💔💔💔💔💔 this downloaded already: \(String(describing: self.activeDownloads[self.currentURL!]?.content.attributes?.name))")
          }
        }
      }
    }

    print("💧💧💧💧💧💧💧💧💧💧💧 \(activeDownloads.count)")
  }
  
  func resumeDownloads() {
    print("\n\n\n\n 🔥🔥🔥🔥🔥 resume downloads")
    var data = [CategoryContentListData]()
    for download in activeDownloads.values {
      data.append(download.content)
    }
    
    while dispatchLeaveCount < dispatchEnterCount {
      dispatch.leave()
      dispatchLeaveCount += 1
    }
    
    self.prepare(queue: data)
  }
  
  /// Downloads the file from the given url
  private func download(url: URL) {
    guard activeDownloads[url] != nil else {return}
    
    let configuration = URLSessionConfiguration.default
    let operationQueue = OperationQueue()
    urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
    
    task = urlSession!.downloadTask(with: url)
    task!.resume()
    
    activeDownloads[url]!.state = .downloading

    dispatchEnterCount += 1
    dispatch.enter()
    dispatch.wait()
  }
  
  var dispatchEnterCount = 0
  var dispatchLeaveCount = 0
  
  ///To Update MusicPlayer;s Download button's UI
  func updateUI(status: DownloadState, percentage: CGFloat) {
    downloadDelegate?.updateButton(state: status, percentage: percentage, url: currentURL)
    downloadDelegate?.updateButton(state: status)
  }
  
  func updateUI(status: DownloadState, percentage: CGFloat, url: URL) {
    downloadDelegate?.updateButton(state: status, percentage: percentage, url: url)
    downloadDelegate?.updateButton(state: status)
  }
  
  ///To Update CourseDetailViewController's Download button's UI
  func updatePlaylistDownloadButton(status: DownloadState, percentage: CGFloat) {
    playlistDownloadDelegate?.updateButton(state: status, percentage: percentage, url: currentURL)
  }
  
  /// Used to update UI when user enters the foreground
  func updateUI() {
    guard let status = currentDownloadState else {
      print("🌈🌈🌈🌈🌈🌈🌈 updateUI() currentDownloadState: \(currentDownloadState)")
      return
    }
    
    let percentage: CGFloat = currentDownloadState == .downloaded ? 1.0 : 0
    downloadDelegate?.updateButton(state: status, percentage: percentage, url: currentURL!)
    downloadDelegate?.updateButton(state: status)
    playlistDownloadDelegate?.updateButton(state: status, percentage: percentage, url: currentURL)
  }
  
  
  ///LocalUrl: Download path URL  - apiUrl: original URL
  func getDownloadState(content: CategoryContentListData,apiUrl: URL) -> DownloadState {
    let localURL = self.getLocalURL(url: apiUrl, id: content.id!)
    
    if isDownloaded(url: localURL) {
      return .downloaded
    } else if activeDownloads[apiUrl] == nil {
      return .startDownload
    } else {
      return activeDownloads[apiUrl]!.state
    }
  }
  
  func isDownloaded(url: URL) -> Bool {
    if FileManager.default.fileExists(atPath: url.path) { //Downloaded before
      return true
    }
    return false
  }
  
  ///Update DownloadButton's UI
  func hasDownloaded(url: URL) -> Bool {
    if isDownloaded(url: url) {
      updateUI(status: .downloaded, percentage: 1.0)
      return true
    } else {
      updateUI(status: .startDownload, percentage: 0.0)
      return false
    }
  }
  
  /// Returns the file's download location
  func getLocalURL(url: URL, id: String) -> URL {
    let localURL = self.documentsDirectoryURL.appendingPathComponent("\(id)_\(url.lastPathComponent)")
    return localURL
  }
  
  
  func pauseDownloads() {
    if let task = self.task {
      task.cancel()
    }
  }
  
  func cancelDownloads(data: [CategoryContentListData], removeDownloadedFiles: Bool) {
    print("🌈🌈🌈🌈🌈 cancelDownloads(data: activeUrl count: \(self.activeDownloads.count)")
    
    for content in data {
      if let url = self.getAPIUrl(link: content.attributes?.media) {
        
        let localUrl = self.getLocalURL(url: url, id: content.id!)
        
        if !self.isDownloaded(url: localUrl) { // Not downloaded
          if url == self.currentURL {
            print("☔️☔️☔️☔️☔️☔️☔️☔️☔️ task.cancel()")
            self.task?.cancel()
            task = nil
          }
          
          self.activeDownloads[self.currentURL!] = nil
          updateUI(status: .startDownload, percentage: 0.0, url: url)
          
        } else { //On the device
          if removeDownloadedFiles == true {
            print("removing file")
            self.removeFile(localURL: localUrl, updatePlaylistCollectionView: true)
          }
        }
        
        if dispatchLeaveCount < dispatchEnterCount {
          dispatch.leave()
          dispatchLeaveCount += 1
        }
        self.activeDownloads[url]?.state = .startDownload
      }
    }
    
    // Update CourseDetailsVC UI
//    AppNotification.shared.updatePlaylistCollectionView()
    DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
      self.updatePlaylistDownloadButton(status: .startDownload, percentage: 0.0) //Update
    })
    
  }
  
  func cancelDownload(url: URL) {
    //TODO: - cancel if we are downloading this content at the moment. Otherwise just remove from the queue.
    if url == currentURL { //Cancel this download now.
      task?.cancel()
      
      if dispatchLeaveCount < dispatchEnterCount { // Prevent crashes
        dispatch.leave()
        dispatchLeaveCount += 1
      }
      
    }
    //activeDownloads[currentURL!] = nil
    activeDownloads[currentURL!]?.state = .startDownload
//    AppNotification.shared.updatePlaylistCollectionView()
    
    print("❄️❄️❄️❄️❄️❄️❄️❄️ activeUrl count: \(activeDownloads.count)")
  }
  
  var destinationUrl: URL? {
    guard let currentDownload = self.currentDownload,
      let currentURL = self.currentURL
      else {
        print("🌜🌜🌜🌜🌜🌜 destinationUrl is nil = currentURL \(String(describing: self.currentURL))")
        return nil
    }
    
    return documentsDirectoryURL.appendingPathComponent("\(currentDownload.content.id!)_\(currentURL.lastPathComponent)")
  }
  
  func removeFile(localURL: URL, updatePlaylistCollectionView: Bool) {
    do {
      try FileManager.default.removeItem(at: localURL)
      updateUI(status: .startDownload, percentage: 0)
      
      if updatePlaylistCollectionView == true {
//        AppNotification.shared.updatePlaylistCollectionView()
      }
      
    } catch {
    }
  }
  
  
  //MARK: - URLSessionDownloadDelegate
  //  var printCount = 0
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
    updateUI(status: .downloading, percentage: percentage) //Update Music Player's Download Button
    updatePlaylistDownloadButton(status: .downloading, percentage: percentage) //Update CourseDetailsViews's Download Button
  }
  
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    // After downloading your file you need to move it to your destination url
    do {
      try FileManager.default.moveItem(at: location, to: destinationUrl!)
      print("✅✅✅✅✅✅✅ File moved to documents folder: \(destinationUrl) \n")
      
      self.updateUI(status: .downloaded, percentage: 1.0)
      self.activeDownloads[self.currentURL!]?.state = .downloaded
      
//      AppNotification.shared.updatePlaylistCollectionView()
      
    } catch let error as NSError {
      print(error.localizedDescription)
    }
    
    if dispatchLeaveCount < dispatchEnterCount {
      dispatch.leave()
      dispatchLeaveCount += 1
    }
  }
  
  func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
    updateUI(status: .startDownload, percentage: 0)
  }
  
  func getAPIUrl(link: String?) -> URL? {
    if let link = link {
      return nil
      //return "\(baseLinkUrl.absoluteString)\(link)".url
    } else {
      return nil
    }
  }
  
}
