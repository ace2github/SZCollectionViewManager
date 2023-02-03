//
//  SZCollectionManager.swift
//  iZeros
//
//  Created by Hui on 2022/12/8.
//

import Foundation
import UIKit

public class SZCollectionManager : NSObject {    // sections
    fileprivate var sectionList: [SZCollectionSection] = [SZCollectionSection]()
    
    // tableview 由外部自行管理
    fileprivate weak var collectionView: UICollectionView?
    
    deinit {
        #if SZTableViewManagerDebug
        print("\(String(describing: Self.self)) \(#function)")
        #endif
        
        // 清理tableview
        collectionView?.delegate = nil
        collectionView?.dataSource = nil
        collectionView = nil
        
        sectionList.removeAll()
    }
    
    public func bindAndRegister(_ collectionV: UICollectionView, _ itemClsList: [SZCollectionItem.Type]) {
        bindTableView(collectionV)
        registerList(itemClsList)
    }
    
    // 1、必须先绑定TableView
    public func bindTableView(_ collectionV: UICollectionView) {
        collectionV.delegate = self
        collectionV.dataSource = self
        
        // 配置TableView
        collectionV.showsHorizontalScrollIndicator = false
        collectionV.showsVerticalScrollIndicator = false

        collectionView = collectionV
    }
    
    // 2、强制采用注册Class的方式
    public func registerList(_ itemClsList: [SZCollectionItem.Type]) {
        for itemCls in itemClsList {
            registerItem(itemCls)
        }
    }
    public func registerItem(_ itemCls: SZCollectionItem.Type) {
        guard let collectionV = collectionView else {
            assert(self.collectionView==nil, "tableview not bind！")
            return
        }
        
        let reuseIdentifier = cellReuseIdentifier(itemCls.cellClass)
        collectionV.register(itemCls.cellClass, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

extension SZCollectionManager {
    public func reload() {
        //assert(Thread.isMainThread, "非主线程刷新")
        collectionView?.reloadData()
    }

    public func reloadSection(_ section: SZCollectionSection) {
        //assert(Thread.isMainThread, "非主线程刷新")
        let si = sectionIndex(section)
        if si >= 0 {
            collectionView?.reloadSections(IndexSet(integer: si))
            collectionView?.reloadInputViews()
        }
    }

    public func reloadItems(_ itemlist: [SZCollectionItem]) {
        //assert(Thread.isMainThread, "非主线程刷新")
        var indexpathList = [IndexPath]()

        for item in itemlist {
            guard let sct = item.section else { return }

            let si = sectionIndex(sct)
            guard si >= 0 else { return }
            
            let ri = sct.itemIndex(item)
            guard ri >= 0 else {
                print("item index out of bounds")
                return
            }
            
            indexpathList.append(IndexPath.init(row: ri, section: si))
        }

        if indexpathList.count > 0 {
            collectionView?.reloadItems(at: indexpathList)
        }
    }

    public func clearDatasource(_ reload: Bool = true) {
        //assert(Thread.isMainThread, "非主线程刷新")

        self.sectionList.removeAll()
        if reload {
            self.reload()
        }
    }
}
    
extension SZCollectionManager {
    public func addSection(_ section: SZCollectionSection) {
        section.manager = self
        self.sectionList.append(section);
    }
    public func addSectionList(_ list: [SZCollectionSection]) {
        for s in list {
            addSection(s)
        }
    }
    public func replaceSectionList(_ list: [SZCollectionSection]) {
        removeAll()
        for s in list {
            addSection(s)
        }
    }

    public func deleteSection(_ section: SZCollectionSection){
        if let index = self.sectionList.firstIndex(of: section) {
            self.sectionList.remove(at: index)
        }
    }
    
    public func safeSection(_ index: Int) -> SZCollectionSection? {
        guard index < self.sectionList.count else {
            return nil
        }
        
        return self.sectionList[index]
    }
    
    public func sectionIndex(_ section: SZCollectionSection) -> Int {
        return self.sectionList.firstIndex(of: section) ?? -1
    }
    
    public func sectionCount() -> Int {
        return self.sectionList.count
    }
    
    public func removeAll() {
        return self.sectionList.removeAll()
    }
}


/*
 需要进行给外部代理的机会
 */
extension SZCollectionManager : UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cellItem = safeSection(indexPath.section)?.safeItem(indexPath.row) else {
            return CGSizeZero
        }
        
        // 计算cell的高度，只计算一次，内部缓存
        if cellItem.didCalcSize == false {
            cellItem.recalcItemSize()
        }
        
        return cellItem.itemSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let sct = safeSection(section) else {
            return UIEdgeInsets.zero
        }
        
        return sct.sectionInset
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let sct = safeSection(section) else {
            return 0.0
        }
        
        return sct.minimumLineSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard let sct = safeSection(section) else {
            return 0.0
        }
        
        return sct.minimumInteritemSpacing
    }
    
}

extension SZCollectionManager : UICollectionViewDelegate {
    //MARK: UITableViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellItem = safeSection(indexPath.section)?.safeItem(indexPath.row)
        if let handler = cellItem?.action.selected {
            handler(cellItem, self)
        }
    }
    
    //MARK: display
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cellItem = safeSection(indexPath.section)?.safeItem(indexPath.row)
        if let tmp_cell = cell as? SZCollectionCell {
            tmp_cell.willAppear(cellItem)
        }
    }
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cellItem = safeSection(indexPath.section)?.safeItem(indexPath.row)
        if let tmp_cell = cell as? SZCollectionCell {
            tmp_cell.didDisappear(cellItem)
        }
    }
}


/*
 需要进行给外部代理的机会
 */
extension SZCollectionManager : UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return safeSection(section)?.cellItems.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: SZCollectionCell? = nil
        
        // 获取item
        let sct = safeSection(indexPath.section)
        let item = sct?.safeItem(indexPath.row)
        
        // 创建 item 对应的 cell
        if let tmp_item = item {
            // 判断是否为SZTableViewCell类型
            if tmp_item.cellClass is SZCollectionCell.Type {
                let reuseIdentifier = cellReuseIdentifier(tmp_item.cellClass)
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SZCollectionCell
            }
        }
        
        item?.section = sct

        // 初始化
        if cell?.loaded == false {
            cell?.loaded = true
            cell?.didLoad(item)
        }
        
        // 配置
        cell?.innerItem = item
        
        // 更新数据
        cell?.didUpdate(item)
        
        return cell!
    }
    
    func cellReuseIdentifier(_ itemCls: AnyClass) -> String {
        return "SZ_\(String(describing: itemCls))"
    }
}
