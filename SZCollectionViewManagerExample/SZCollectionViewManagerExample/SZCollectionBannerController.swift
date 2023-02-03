//
//  SZCollectionViewManagerController.swift
//  SZCollectionViewManagerExample
//
//  Created by Hui on 2023/2/3.
//

import Foundation
import UIKit
import SZCollectionViewManager

class SZCollectionBannerController : UIViewController {
    lazy var manager: SZCollectionManager = {
        return SZCollectionManager.init()
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collect.backgroundColor = .darkGray
        collect.isPagingEnabled = true
        return collect
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)

            make.centerY.equalToSuperview()
            make.height.equalTo(200)
        }

        self.manager.bindAndRegister(self.collectionView, [
            SZImageCollectionCellItem.self,
        ])

        let section = SZCollectionSection()
        
        var imageList = [
            "https://t7.baidu.com/it/u=2621658848,3952322712&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=3631608752,3069876728&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=1415984692,3889465312&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=4080826490,615918710&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=334080491,3307726294&fm=193&f=GIF"
        ]
        var list = [SZImageCollectionCellItem]()
        for url in imageList {
            let item = SZImageCollectionCellItem()
            item.imageUrl = url
            list.append(item)
        }
        section.addItemList(list)
        
        self.manager.addSection(section)
        
    }
}
