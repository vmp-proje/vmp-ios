import UIKit

class FlowCollectionView: View, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: - UI Objects
        
    let myCellIdentifier : String = "myCell"
    
    let flowCollectionView: UICollectionView = { // Scroll Up and Down
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(InsiderCollectionView.self, forCellWithReuseIdentifier: "myCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        setupCollectionView()
        flowCollectionView.dataSource = self
        flowCollectionView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Layout
    
    func setupCollectionView() {
        addSubview(flowCollectionView)
        
        flowCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        flowCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        flowCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        flowCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    //MARK: - Collection View Data Source
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myCellIdentifier, for: indexPath) as! InsiderCollectionView
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("FlowCollectionView.swift Tıklandı.")
    }
    
    //MARK: - Collection View Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 350)
    }
}

    //MARK: - Insider Collection View Class

class InsiderCollectionView: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView!
    let cellReuseIdentifier:String = "myInnerCell"
    var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()


    override init(frame: CGRect) {
        super.init(frame: frame)

        self.layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.layout.itemSize = CGSize(width:self.frame.width-40, height:self.frame.height-100)
        self.layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        self.collectionView = UICollectionView(frame:self.frame, collectionViewLayout: self.layout)
        self.collectionView.backgroundColor = .black
        self.collectionView.frame = self.bounds
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(MusicCollectionViewCell.self, forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.reloadData()
        self.addSubview(self.collectionView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath as IndexPath) as! MusicCollectionViewCell
        return cell
    }

}

