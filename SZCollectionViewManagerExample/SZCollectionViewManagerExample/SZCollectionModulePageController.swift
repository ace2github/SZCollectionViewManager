//
//  SZCollectionModulePageController.swift
//  SZCollectionViewManagerExample
//
//  Created by Hui on 2023/2/3.
//

import Foundation
import Foundation
import UIKit
import SZCollectionViewManager

class SZCollectionModulePageController : UIViewController {
    lazy var manager: SZCollectionManager = {
        return SZCollectionManager.init()
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collect.backgroundColor = .lightGray
        collect.isPagingEnabled = true
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

        let imageList = [
            "https://t7.baidu.com/it/u=2621658848,3952322712&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=3631608752,3069876728&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=1415984692,3889465312&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=4080826490,615918710&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=334080491,3307726294&fm=193&f=GIF"
        ]
        let csize = CGSize(width: UIScreen.main.bounds.size.width - 20*2, height: height)
        
        let row:Int = 3
        let column:Int = 4
        
        var list = [SZIconTitleCollectionCellItem]()
        for i in 0..<43 {
            let item = SZIconTitleCollectionCellItem()
            item.itemSize = CGSize(width: csize.width / Double(column), height: csize.height / Double(row))
            item.didCalcSize = true
            
            item.iconUrl = imageList[i%imageList.count]
            item.title = "module \(i)"
            list.append(item)
        }
                
        let section = SZCollectionSection()
        let pageItemList = reorderModuleListForPageList(list: list, row: row, column: column) {
            let item = SZIconTitleCollectionCellItem()
            item.itemSize = CGSize(width: csize.width / Double(column), height: csize.height / Double(row))
            item.didCalcSize = true
            return item
        }
        section.addItemList(pageItemList)
        manager.addSection(section)
    }
    
    /// 会返回满页的items，然后在cell里面对于非正常item进行隐藏
    func reorderModuleListForPageList(
        list:[SZIconTitleCollectionCellItem],
        row: Int,
        column: Int,
        createItemBlk:()->SZIconTitleCollectionCellItem
    ) -> [SZIconTitleCollectionCellItem]
    {
        
        var pageList = [SZIconTitleCollectionCellItem]()
        
        // 计算页数
        let pageElementCounts:Int = Int(row * column)
        let totalPageCount = ceilf(Float(list.count) / Float(pageElementCounts))
        
        for i in 0..<Int(totalPageCount) {
            let startIdx = i * pageElementCounts
            
            for x in 0..<column { // 列
                for y in 0..<row { // 行
                    let idx = startIdx + y * column + x
                    if idx < list.count {
                        let item = list[idx]
                        pageList.append(item)
                        
                    } else {
                        let item = createItemBlk()
                        item.hidden = true
                        pageList.append(item)
                    }
                }
            }
        }
        
        return pageList
    }
}
