//
//  DownloadState.swift
//  VmpProjectios
//
//  Created by Anil Joe on 12.04.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import UIKit


enum DownloadState {
  case startDownload
  case downloading
  case downloaded
  
  func getIcon() -> UIImage {
    switch self {
    case .startDownload:
      return UIImage(named: "icon-download")!.withRenderingMode(.alwaysTemplate)
    case .downloading:
      return UIImage(named: "downloading")!.withRenderingMode(.alwaysTemplate)
    case .downloaded:
      return UIImage(named: "downloaded")!.withRenderingMode(.alwaysTemplate)
    }
  }
  
  func getPercentage() -> CGFloat {
    switch self {
    case .startDownload:
      return 0.0
    case .downloading:
      return 0.0
    case .downloaded:
      return 1.0
    }
  }
  
}
