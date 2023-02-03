//
//  SZCollectionModuleController.swift
//  SZCollectionViewManagerExample
//
//  Created by Hui on 2023/2/3.
//

import Foundation
import Foundation
import UIKit
import SZCollectionViewManager

class SZCollectionModuleController : UIViewController {
    lazy var manager: SZCollectionManager = {
        return SZCollectionManager.init()
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collect.backgroundColor = .lightGray
        //collect.isPagingEnabled = true
        return collect
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.collectionView)
        let height: Double = 90 * 3
        self.collectionView.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.centerY.equalToSuperview()
            make.height.equalTo(height)
        }

        self.manager.bindAndRegister(self.collectionView, [
            SZIconTitleCollectionCellItem.self,
        ])

        let section = SZCollectionSection()
        let imageList = [
            "https://t7.baidu.com/it/u=2621658848,3952322712&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=3631608752,3069876728&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=1415984692,3889465312&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=4080826490,615918710&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=334080491,3307726294&fm=193&f=GIF"
        ]
        var list = [SZIconTitleCollectionCellItem]()
        let csize = CGSize(width: UIScreen.main.bounds.size.width - 20*2, height: height)
        for i in 0...32 {
            let item = SZIconTitleCollectionCellItem()
            
            item.itemSize = CGSize(width: csize.width / 4, height: csize.height / 3)
            item.didCalcSize = true
            
            item.iconUrl = imageList[i%imageList.count]
            item.title = "module \(i)"
            list.append(item)
        }
        section.addItemList(list)
        
        self.manager.addSection(section)
    }
}
