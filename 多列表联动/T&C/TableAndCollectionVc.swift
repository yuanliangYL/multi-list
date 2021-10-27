//
//  TableAndCollectionVc.swift
//  多列表联动
//
//  Created by AlbertYuan on 2021/10/27.
//

/*
 （1）左侧 tableView 联动右侧 collectionView 比较简单。只要点击时获取对应索引值，然后让右侧 collectionView 滚动到相应的分区头即可。
 （2）右侧 collectionView 联动左侧 tableView 麻烦些。我们需要在右侧 collectionView 的分区头显示或消失时，触发左侧 tableView 的选中项改变：
 当右侧 collectionView 分区头即将要显示时：如果此时是向上滚动，且是由用户滑动屏幕造成的，那么左侧 tableView 自动选中该分区对应的分类。
 当右侧 collectionView 分区头即将要消失时：如果此时是向下滚动，且是由用户滑动屏幕造成的，那么左侧 tableView 自动选中该分区对应的下一个分区的分类。
 */
import UIKit

class TableAndCollectionVc: UIViewController {

    //左侧tableView
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: 80, height: UIScreen.main.bounds.height-88)
        tableView.rowHeight = 55
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = UIColor.clear
        tableView.register(TableViewCell.self,
                           forCellReuseIdentifier: "tableViewCell")
        tableView.backgroundColor = .yellow
//        tableView.contentInset
//        tableView.adjustedContentInset

        return tableView
    }()

    //右侧collectionView的布局
    lazy var flowlayout : UICollectionViewFlowLayout = {

        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        flowlayout.minimumLineSpacing = 2
        flowlayout.minimumInteritemSpacing = 2
        //分组头悬停
//        flowlayout.sectionHeadersPinToVisibleBounds = true
//        flowlayout.sectionFootersPinToVisibleBounds = false
        let itemWidth = (UIScreen.main.bounds.width - 80 - 4 - 4) / 3
        flowlayout.itemSize = CGSize(width: itemWidth,height: itemWidth + 30)
        return flowlayout
    }()

    //右侧collectionView
    lazy var collectionView : UICollectionView = {

        let collectionView = UICollectionView(frame: CGRect.init(x: 2 + 80, y: 0,
                                                                 width: UIScreen.main.bounds.width - 80 - 4,
                                                                 height: UIScreen.main.bounds.height-88),
                                              collectionViewLayout: self.flowlayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.brown
        collectionView.register(CollectionViewCell.self,
                                forCellWithReuseIdentifier: "collectionViewCell")

        collectionView.register(CollectionViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "collectionViewHeader")
        return collectionView
    }()

    //左侧tableView数据
    var tableViewData = [String]()
    //右侧collectionView数据
    var collectionViewData = [[CollectionViewModel]]()

    //右侧collectionView当前是否正在向下滚动（即true表示手指向上滑动，查看下面内容）
    var collectionViewIsScrollDown = true
    //右侧collectionView垂直偏移量
    var collectionViewLastOffsetY : CGFloat = 0.0


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white



//        设置坐标系模式：iOS7之前的坐标系见图一，坐标原点是从导航栏下方开始计算的，iOS7以后的坐标系是铺满全屏幕的（图二），也就是将屏幕的左上角作为坐标原点
        //edgesForExtendedLayout属性只是改变了坐标系原点的位置，并不会改变view的宽度和高度，也就是说无论该属性被设置成哪一个值，控制器父视图的默认frame都是 (0.0,0.0,Screen.Width,Screen.Height)，所以使用父视图的frame属性给其他子视图时要注意
        self.edgesForExtendedLayout = [] //表示从导航距离开始,默认是all




//        注释掉系统的自动规避遮挡，自定在定义frame的时候设置
        //ios13
//        if #available(iOS 11, *) {
//            //iOS11之后针对每一个起作用
//            self.tableView.contentInsetAdjustmentBehavior = .automatic
//            self.collectionView.contentInsetAdjustmentBehavior = .automatic
//        } else {
//            /*
//             先来看看官方文档怎么说，automaticallyAdjustsScrollViewInsets根据按所在界面的status bar，navigationbar，与tabbar的高度，自动调整scrollview的contentInset，设置为No，不让viewController调整，我们自己修改布局即可~。该属性是针对scrollview及其子类的，例如tableView和collectionView，但是该属性只对控制器视图层级中第一个scrollview及其子类起作用，如果视图层级中存在多个scrollview及其子类，官方建议该属性设置为No，此时应该手动设置它的contentInset
//             */
//            self.automaticallyAdjustsScrollViewInsets = true
//        }

        //初始化左侧表格数据
        for i in 1..<35 {

            self.tableViewData.append("分类\(i)")

        }

        //初始化右侧表格数据
        for _ in tableViewData {
            var models = [CollectionViewModel]()
            for i in 1..<6 {
                models.append(CollectionViewModel(name: "型号\(i)", picture: "image"))
            }
            self.collectionViewData.append(models)
        }

        //将tableView和collectionView添加到页面上
        view.addSubview(tableView)
        view.addSubview(collectionView)

        //左侧表格默认选中第一项
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true,scrollPosition: .none)

        //print(tableView.contentInset,tableView.adjustedContentInset)
    }
}



// tableView相关的协议方法
extension TableAndCollectionVc:UITableViewDelegate,UITableViewDataSource{
    //表格分区数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //分区下单元格数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }

    //返回自定义单元格
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell",
                                                 for: indexPath) as! TableViewCell
        cell.titleLabel.text = tableViewData[indexPath.row]
        return cell
    }

    //单元格选中时调用
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //右侧collection自动滚动到对应的分区
        collectionViewScrollToTop(section: indexPath.row, animated: true)

        //左侧tableView将该单元格滚动到顶部
        tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: 0),
                              at: .top , animated: true)
    }
}


// tableView点击自定义方法
extension TableAndCollectionVc{

    //将右侧colletionView的指定分区自动滚动到最顶端
    func collectionViewScrollToTop(section: Int, animated: Bool) {

        //头部高度
        let headerRect = collectionViewHeaderFrame(section: section)
        let topOfHeader = CGPoint(x: 0, y: headerRect.origin.y - collectionView.contentInset.top)
        print("topOfHeader",topOfHeader)

        collectionView.setContentOffset(topOfHeader, animated: animated)

    }

    //colletionView的指定分区头的高度
    func collectionViewHeaderFrame(section: Int) -> CGRect {

        //分区收个cell
        let indexPath = IndexPath(item: 0, section: section)

        //头部布局
        let attributes = collectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath)

        guard let frameForheader = attributes?.frame else {
            return .zero
        }
        print(section,frameForheader)

        return frameForheader;
    }

}


extension TableAndCollectionVc: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    // 获取分区数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tableViewData.count
    }

    // 分区下单元格数量
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return collectionViewData[section].count
    }

    //返回自定义单元格
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                        "collectionViewCell", for: indexPath) as! CollectionViewCell
        let model = collectionViewData[indexPath.section][indexPath.row]
        cell.setData(model)
        return cell
    }

    //分区头尺寸

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: UIScreen.main.bounds.width, height: 30)
    }

    //返回自定义分区头
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        let view = collectionView.dequeueReusableSupplementaryView(ofKind:
                                                                    UICollectionView.elementKindSectionHeader,
                                                                   withReuseIdentifier: "collectionViewHeader",
                                                                   for: indexPath) as! CollectionViewHeader
        view.titleLabel.text = tableViewData[indexPath.section]
        return view
    }


    //分区头即将要显示时调用
    func collectionView(_ collectionView: UICollectionView,
                        willDisplaySupplementaryView view: UICollectionReusableView,
                        forElementKind elementKind: String, at indexPath: IndexPath) {

        //如果是由用户手动滑动屏幕造成的向上滚动，那么左侧表格自动选中该分区对应的分类
        if !collectionViewIsScrollDown
            && (collectionView.isDragging || collectionView.isDecelerating) {
            tableView.selectRow(at: IndexPath(row: indexPath.section, section: 0),
                                animated: true, scrollPosition: .top)
        }
    }

    //分区头即将要消失时调用
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplayingSupplementaryView view: UICollectionReusableView,
                        forElementOfKind elementKind: String, at indexPath: IndexPath) {
        //如果是由用户手动滑动屏幕造成的向下滚动，那么左侧表格自动选中该分区对应的下一个分区的分类
        if collectionViewIsScrollDown
            && (collectionView.isDragging || collectionView.isDecelerating) {
            tableView.selectRow(at: IndexPath(row: indexPath.section + 1, section: 0),
                                animated: true, scrollPosition: .top)
        }
    }



}

extension TableAndCollectionVc:UIScrollViewDelegate{
    //视图滚动时触发（主要用于记录当前collectionView是向上还是向下滚动）
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView == scrollView {
            collectionViewIsScrollDown = collectionViewLastOffsetY
                < scrollView.contentOffset.y
            collectionViewLastOffsetY = scrollView.contentOffset.y
        }
    }
}


//UIColor扩展
extension UIColor {
    //使用rgb方式生成自定义颜色
    convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat) {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    //使用rgba方式生成自定义颜色
    convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat, _ a : CGFloat) {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: a)
    }
}

