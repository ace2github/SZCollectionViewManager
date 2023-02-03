//
//  SZCollectionItem.swift
//  iZeros
//
//  Created by Hui on 2022/12/8.
//

import Foundation
import UIKit

open class SZCollectionItem : NSObject {
    // action
    open lazy var action: SZCollectionItemAction = {
        return SZCollectionItemAction()
    }()
        
    /*
     * cell相关的配置信息
     */
    /*
     * cell的高度
     * 如果是自动高度模式，则为预估高度值
     */
    public var itemSize: CGSize = CGSizeZero
    
    
    // 如果提前计算好高度，可以将其设置为true避免重复计算
    public var didCalcSize = false
    
    public override init() {
        super.init()
    }
    
    public convenience init(_ calc: Bool = false) {
        self.init()
        
        if calc {
            itemSize = calcItemSize()
        }
    }
    
    #if SZTableViewManagerDebug
    deinit {
        print("\(String(describing: Self.self)) \(#function)")
    }
    #endif
    
    // 当前item对应的section
    public weak var section: SZCollectionSection?
    
    // 推荐在Item数据初始化完成后，就计算cell的高度
    // 如果放到cell height里面再去计算，会有一定的性能消耗
    open func recalcItemSize() {
        itemSize = calcItemSize()
        didCalcSize = true
    }
    
    // 子类重写，返回与当前Item对应的Cell
    open class var cellClass: AnyClass {
        return SZCollectionCell.self
    }
    
    /*
     * 子类重写，返回当前Cell默认的高度
     * 如果是自动高度模式，则为预估高度值
     */
    open func calcItemSize() -> CGSize {
        return CGSize(width: 40, height: 40)
    }
}

extension SZCollectionItem {
    var cellClass: AnyClass {
        return Self.cellClass
    }
}

extension SZCollectionItem {
    public func reloadCurrentItem() {
        section?.reloadCurrentItem(self)
    }
}

//MARK: Item.Action
open class SZCollectionItemAction {
    open var selected: ((_ vi: SZCollectionItem? ,_ mgr: SZCollectionManager) -> Void)?
}
