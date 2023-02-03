//
//  SZImageCCell.swift
//  SZCollectionViewManagerExample
//
//  Created by Hui on 2023/2/3.
//

import Foundation
import SZCollectionViewManager

import SnapKit
import Kingfisher

class SZImageCollectionCell : SZCollectionCell {
    lazy var imageView: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        return imgV
    }()
    override func didLoad(_ item: SZCollectionItem?) {
        super.didLoad(item)
        self.contentView.backgroundColor = .orange
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func didUpdate(_ item: SZCollectionItem?) {
        super.didLoad(item)
        guard let cellItem = item as? SZImageCollectionCellItem else {
            return
        }
        
        imageView.kf.setImage(with: URL.init(string: cellItem.imageUrl ?? ""))
    }
}

class SZImageCollectionCellItem : SZCollectionItem {
    var imageUrl: String?
    override class var cellClass: AnyClass {
        return SZImageCollectionCell.self
    }
    
    override open func calcItemSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width-20*2, height: 180)
    }
}

