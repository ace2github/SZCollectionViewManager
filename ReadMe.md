
### 概述
SZCollectionViewManager适用于UIKit快速根据Data快速构建CollectionView列表

* 核心理念：数据驱动

### 实践
* 0、理论 item-cell 是一一对应的关系 


### 实践
1、自定义 `SZCollectionCell` 和 `SZCollectionItem` 的子类
```
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
```

2、创建 Manager 和 CollectionView
```
// ViewController
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

// 绑定
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


// 创建数据
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

let section = SZCollectionSection()
section.addItemList(list)
self.manager.addSection(section)
```
