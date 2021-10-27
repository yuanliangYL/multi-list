//
//  CollectionViewHeader.swift
//  多列表联动
//
//  Created by AlbertYuan on 2021/10/27.
//

import UIKit

//右侧collectionView的自定义分区头
class CollectionViewHeader: UICollectionReusableView {

    //分区头文本标签
    var titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        //设置分区头背景色
        backgroundColor = UIColor.white

        //初始化分区头文本标签
        titleLabel.frame = CGRect(x: 15, y: 0, width: 200, height: 30)
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        addSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
