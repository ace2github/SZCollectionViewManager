//
//  SZCollectionSection.swift
//  iZeros
//
//  Created by Hui on 2022/12/8.
//

import Foundation
import UIKit

open class SZCollectionSection: NSObject {
    var cellItems: [SZCollectionItem] = [SZCollectionItem]()
    
    public weak var manager: SZCollectionManager?
    
    // 每个分区的EdgeInsets
    public var sectionInset: UIEdgeInsets = UIEdgeInsets.zero
    // 每行的间距大小
    public var minimumLineSpacing: CGFloat = 0.0
    // 每列的间距大小
    public var minimumInteritemSpacing: CGFloat = 0.0
    
    //MARK: Header
    // 自动高度
    public var estimatedHeader: Bool = false
    public var headerHeight: Float = 0.0
    public var headerView: UICollectionReusableView? = nil
    
    //MARK: Footer
    public var estimatedFooter: Bool = false
    public var footerHeight: Float = 0.0
    public var footerView: UICollectionReusableView? = nil

    public override init() {
        super.init()
        headerHeight = Self.calcHeaderHeight()
        footerHeight = Self.calcFooterHeight()
    }
    
    deinit {
        #if SZTableViewManagerDebug
        print("\(String(describing: Self.self)) \(#function)")
        #endif
        
        cellItems.removeAll()
        
        footerView?.removeFromSuperview()
        footerView = nil
        
        headerView?.removeFromSuperview()
        headerView = nil
    }
    
    open class func calcHeaderHeight() -> Float {
        return 0.0
    }
    open class func calcFooterHeight() -> Float {
        return 0.0
    }
}


extension SZCollectionSection {
    func safeItem(_ index: Int) -> SZCollectionItem? {
        guard index < self.cellItems.count else {
            return nil
        }
        
        return self.cellItems[index]
    }
    
    public func addItem(_ item: SZCollectionItem) {
        item.section = self
        self.cellItems.append(item);
    }
    
    public func addItemList(_ itemList: [SZCollectionItem]) {
        for item in itemList {
            addItem(item)
        }
    }
    
    public func replaceItemList(_ itemList: [SZCollectionItem]) {
        removeAll()
        
        for item in itemList {
            addItem(item)
        }
    }
    
    public func insertItem(_ item: SZCollectionItem, _ atIndex:Int) -> Bool{
        if atIndex < self.cellItems.count {
            item.section = self
            self.cellItems.insert(item, at: atIndex)
            return true
        }
        return false
    }
    
    public func deleteItem(_ item: SZCollectionItem){
        if let index = self.cellItems.firstIndex(of: item) {
            self.cellItems.remove(at: index)
        }
    }
    
    public func itemIndex(_ item: SZCollectionItem) -> Int {
        return self.cellItems.firstIndex(of: item) ?? -1
    }
    
    public func itemCount() -> Int {
        return self.cellItems.count
    }
    
    public func removeAll() {
        return self.cellItems.removeAll()
    }
}


extension SZCollectionSection {
    public func reloadCurrentSection() {
        manager?.reloadSection(self)
    }

    public func reloadCurrentItem(_ item: SZCollectionItem) {
        manager?.reloadItems([item])
    }
}
