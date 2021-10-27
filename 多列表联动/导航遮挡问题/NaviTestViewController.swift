//
//  NaviTestViewController.swift
//  多列表联动
//
//  Created by AlbertYuan on 2021/10/27.
//

import UIKit

class NaviTestViewController: UIViewController {

    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        tableView.rowHeight = 55
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = UIColor.clear
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "recell")
        tableView.backgroundColor = .yellow
//        tableView.contentInset
//        tableView.adjustedContentInset
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        defaultState()
//        noneState()
//        noneForcontentInsetAdjustmentBehaviorState()
        noneForAllState()


        view.backgroundColor = .cyan
        view.addSubview(tableView)

    }


}


extension NaviTestViewController{

//1.**edgesForExtendedLayout**和**automaticallyAdjustsScrollViewInsets(contentInsetAdjustmentBehavior)**均为默认值：all、yes、automatic 
    func defaultState(){

        //print(automaticallyAdjustsScrollViewInsets,tableView.contentInsetAdjustmentBehavior.rawValue)
        edgesForExtendedLayout = .all //default all:全屏幕
        if #available(iOS 11, *) {
            //iOS11之后针对每一个起作用
            tableView.contentInsetAdjustmentBehavior = .automatic //default automatic
        }else{
            automaticallyAdjustsScrollViewInsets = true //default true
        }
    }


//    2.**edgesForExtendedLayou**t均为**UIRectEdgeNone
    func noneState(){
        //print(automaticallyAdjustsScrollViewInsets,tableView.contentInsetAdjustmentBehavior.rawValue)
        edgesForExtendedLayout = [] //导航下
        if #available(iOS 11, *) {
            //iOS11之后针对每一个起作用
            tableView.contentInsetAdjustmentBehavior = .automatic //default automatic
        }else{
            automaticallyAdjustsScrollViewInsets = true //default true
        }
    }


//    3.**edgesForExtendedLayout**为默认，iOS11以前**automaticallyAdjustsScrollViewInsets**为**No**（iOS11以后**contentInsetAdjustmentBehavior为never），**只看TableView
    func noneForcontentInsetAdjustmentBehaviorState(){
        //print(automaticallyAdjustsScrollViewInsets,tableView.contentInsetAdjustmentBehavior.rawValue)
        edgesForExtendedLayout = .all //导航下
        if #available(iOS 11, *) {
            //iOS11之后针对每一个起作用
            tableView.contentInsetAdjustmentBehavior = .never //default automatic
        }else{
            automaticallyAdjustsScrollViewInsets = false //default true
        }
    }


    //4.edgesForExtendedLayout为UIRectEdgeNone，iOS11以前automaticallyAdjustsScrollViewInsets为No（iOS11以后contentInsetAdjustmentBehavior为never），只看TableView
    func noneForAllState(){
        //print(automaticallyAdjustsScrollViewInsets,tableView.contentInsetAdjustmentBehavior.rawValue)
        edgesForExtendedLayout = [] //导航下
        if #available(iOS 11, *) {
            //iOS11之后针对每一个起作用
            tableView.contentInsetAdjustmentBehavior = .never //default automatic
        }else{
            automaticallyAdjustsScrollViewInsets = false //default true
        }
    }

}

extension NaviTestViewController:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "recell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}
