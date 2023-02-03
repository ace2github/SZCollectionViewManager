//
//  SZCollectionCell.swift
//  iZeros
//
//  Created by Hui on 2022/12/8.
//

import Foundation
import UIKit

protocol SZCollectionCellLifeCircel {
    // 首次创建调用
    func didLoad(_ item: SZCollectionItem?)
    
    // 更新的时候调用，
    func didUpdate(_ item: SZCollectionItem?)
    
    //
    func willAppear(_ item: SZCollectionItem?)
    func didDisappear(_ item: SZCollectionItem?)
}

open class SZCollectionCell: UICollectionViewCell, SZCollectionCellLifeCircel {
    public weak var innerItem: SZCollectionItem? = nil
    var loaded: Bool = false
    
    #if SZTableViewManagerDebug
    deinit {
        print("\(String(describing: Self.self)) \(#function)")
    }
    #endif
    
    // 首次创建调用
    open func didLoad(_ item: SZCollectionItem?) {
        self.loaded = true
        
        // cell 样式配置
        
    }
    
    open func didUpdate(_ item: SZCollectionItem?) {
        
    }
    open func willAppear(_ item: SZCollectionItem?) {
        
    }
    open func didDisappear(_ item: SZCollectionItem?) {
        
    }
}

