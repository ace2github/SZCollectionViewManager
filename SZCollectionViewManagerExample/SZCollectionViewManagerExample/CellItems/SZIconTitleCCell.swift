//
//  SZIconTitleCCell.swift
//  SZCollectionViewManagerExample
//
//  Created by Hui on 2023/2/3.
//

import Foundation
import Foundation
import SZCollectionViewManager

import SnapKit
import Kingfisher

class SZIconTitleCollectionCell : SZCollectionCell {
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        imgV.layer.cornerRadius = 6.0
        return imgV
    }()
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.textColor = .black
        lbl.font = .systemFont(ofSize: 16)
        return lbl
    }()
    
    override func didLoad(_ item: SZCollectionItem?) {
        super.didLoad(item)
        
        self.contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 48, height: 48))
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        self.contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalTo(iconView.snp.bottom).offset(8)
            make.height.greaterThanOrEqualTo(0)
        }
    }
    
    override func didUpdate(_ item: SZCollectionItem?) {
        super.didLoad(item)
        guard let cellItem = item as? SZIconTitleCollectionCellItem else {
            return
        }
        
        titleLbl.text = cellItem.title ?? ""
        iconView.kf.setImage(with: URL.init(string: cellItem.iconUrl ?? ""))
        
        contentView.isHidden = cellItem.hidden
    }
}

class SZIconTitleCollectionCellItem : SZCollectionItem {
    var hidden: Bool = false
    var iconUrl: String?
    var title: String?
    
    override class var cellClass: AnyClass {
        return SZIconTitleCollectionCell.self
    }
    override func calcItemSize() -> CGSize {
        return CGSize(width: 1, height: 1)
    }
}
