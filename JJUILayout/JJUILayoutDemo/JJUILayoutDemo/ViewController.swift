//
//  ViewController.swift
//  JJUILayoutDemo
//
//  Created by 李杰駿 on 2020/6/6.
//  Copyright © 2020 李杰駿. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let _tableView : UITableView = UITableView()
    private var _tableViewDelegate : JJTableViewDelegate?
    private let pages : [String:AnyClass] = [
        "tableViewDemo" : TableViewControllerDemo.self,
        "staticSheetViewController" : JJStaticSheetViewController.self
    ]
    
    private func exceptHandle(_ targetVC : UIViewController) {
        if let staticSheet = targetVC as? JJStaticSheetViewController {
            
            var myModel : [[String:Any]] = [
                [
                    kJJStaticSheetCardType : "cell1",
                    kJJStaticSheetCardModel : ["name": "cell1"],
                    kJJStaticSheetCardHeight : 60
                ],
                [
                    kJJStaticSheetCardType : "cell2",
                    kJJStaticSheetCardModel : ["name": "cell2"],
                    kJJStaticSheetCardHeight : 80,
                    "isExpand" : 1
                ],
                [
                    kJJStaticSheetCardType : "cell1",
                    kJJStaticSheetCardModel : ["name": "cell1"],
                    kJJStaticSheetCardHeight : 44
                ],
            ]
            
            staticSheet
                .registCardType(cardType: "cell1", withClass: My1Cell.self)
                .registCardType(cardType: "cell2", withClass: My2Cell.self)
                .handleEvents { (indexPath, eventName, data) in
                    if (eventName == "buttonTap") {
                        print("\(data)")
                        myModel[1]["isExpand"] = (myModel[1]["isExpand"] as! Int) ^ 1
                        let isExpand = myModel[1]["isExpand"] as! Int
                        myModel[1][kJJStaticSheetCardHeight] = (isExpand > 0) ? 80 : 50
                        staticSheet.addSheetModel(myModel)
                    }
            }
            
            staticSheet.addSheetModel(myModel)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _tableViewDelegate = JJTableViewDelegate(_tableView)
            .registWithCellStructs(["cellList" : JJCustomCellStruct(itemView: ViewControllerCell.self)])
            .numOfSection(1)
            .numOfRowInSection({[unowned self] (section) -> Int in
                return self.pages.count
            })
            .cellReuseIdentifierWithIndex({ (section, row) -> String in
                return "cellList"
            })
            .modelWithIndex({ [unowned self](section, row) -> Any in
                let index = self.pages.index(self.pages.startIndex, offsetBy: row)
                let titleName = self.pages.keys[index]
                return ["name" : titleName]
            })
            .select({ [unowned self](section, row) in
                let index = self.pages.index(self.pages.startIndex, offsetBy: row)
                guard let classType = self.pages.values[index] as? NSObject.Type else {return}
                guard let targetVC = classType.init() as? UIViewController else {
                    return
                }
                self.exceptHandle(targetVC)
                self.navigationController?.pushViewController(targetVC, animated: true)
            })
        
        _tableView.delegate = _tableViewDelegate
        _tableView.dataSource = _tableViewDelegate
        
        self.view.addSubview(_tableView)
        _tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            _tableView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            _tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            _tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            _tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
        ])
    }
    

}

class ViewControllerCell: JJCustomCellItemView<[String:Any]> {
    let _label : UILabel = UILabel()
    override func initUI() {
        super.initUI()
        self.addSubview(_label)
        _label.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            _label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            _label.leftAnchor.constraint(equalTo: self.leftAnchor),
        ])
    }
    override func updateUI(_ data: [String : Any]) {
        super.updateUI(data)
        _label.text = data["name"] as? String
    }
}

