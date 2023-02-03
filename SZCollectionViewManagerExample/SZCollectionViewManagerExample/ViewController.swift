//
//  ViewController.swift
//  SZCollectionViewManagerExample
//
//  Created by Hui on 2023/2/2.
//

import UIKit
import SnapKit
import SZTableViewManager

class ViewController: UIViewController {
    lazy var tblManager: SZTableViewManager = {
        let mgr = SZTableViewManager()
        mgr.bindTableView(tableview)
        mgr.registerList([
            SZTitleCellItem.self,
        ])
        return mgr
    }()
    lazy var tableview: UITableView = {
        let tblV = UITableView(frame:self.view.bounds, style:.plain)
        return tblV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        let section: SZTableViewSection = SZTableViewSection.init()
        section.addItemList(createItems())
        tblManager.addSection(section)
    }

    func createItems() -> [SZTableViewItem] {
        var list = [SZTableViewItem]()
        
        var item = SZTitleCellItem()
        item.title = "轮播图-Banner"
        item.action.selected = { [weak self] (_ vi: SZTableViewItem? ,_ tblMgr: SZTableViewManager) in
            if let cellItem = vi as? SZTitleCellItem {
                print("click: \(cellItem.title)")
                self?.navigationController?.pushViewController(SZCollectionBannerController.init(), animated: true)
            }
        }
        list.append(item)
        
        
        item = SZTitleCellItem()
        item.title = "模块列表-module"
        item.action.selected = { [weak self] (_ vi: SZTableViewItem? ,_ tblMgr: SZTableViewManager) in
            if let cellItem = vi as? SZTitleCellItem {
                print("click: \(cellItem.title)")
                self?.navigationController?.pushViewController(SZCollectionModuleController.init(), animated: true)
            }
        }
        list.append(item)
        
        item = SZTitleCellItem()
        item.title = "分页.模块列表-module"
        item.action.selected = { [weak self] (_ vi: SZTableViewItem? ,_ tblMgr: SZTableViewManager) in
            if let cellItem = vi as? SZTitleCellItem {
                print("click: \(cellItem.title)")
                self?.navigationController?.pushViewController(SZCollectionModulePageController.init(), animated: true)
            }
        }
        list.append(item)
        
        return list
    }

}

