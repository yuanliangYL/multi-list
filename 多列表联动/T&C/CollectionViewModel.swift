//
//  CollectionViewModel.swift
//  多列表联动
//
//  Created by AlbertYuan on 2021/10/27.
//

import UIKit

//右侧collectionView的数据模型（大分类下的小分类）
class CollectionViewModel: NSObject {

    //小分类名称
    var name : String
    //小分类图片
    var picture : String

    init(name: String, picture: String) {
        self.name = name
        self.picture = picture
    }
}
