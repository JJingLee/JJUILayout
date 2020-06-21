//
//  JJStaticSheetViewController.swift
//  JJUILayoutDemo
//
//  Created by 李杰駿 on 2020/6/21.
//  Copyright © 2020 李杰駿. All rights reserved.
//

import UIKit


let kJJStaticSheetCardHeight = "cardHeight"
let kJJStaticSheetCardType = "cardType"
let kJJStaticSheetCardModel = "cardModel"


 let mockdata = [
    [
        kJJStaticSheetCardType : "",
        kJJStaticSheetCardModel : ["name": "noOdd"],
        kJJStaticSheetCardHeight : 60
    ],
 ]
 


class JJStaticSheetViewController: UIViewController {

    let _tableView = UITableView()
    var _tableViewDelegate : JJTableViewDelegate?
    /**
     [
        [
            "cardType":"",
            "data" : Any
        ],
     ]
     */
//    var _resultData : [String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configTableView()
    }
    
    deinit {
        print("deinit")
    }
    
    //MARK: - public func
    private var _cardTypeMap : [String:JJCellItemViewProtocol.Type] = [:]
    /** CardType have to be unique */
    func registCardType(cardType:String,
                        withClass cardClass:JJCellItemViewProtocol.Type) ->JJStaticSheetViewController {
        _cardTypeMap[cardType] = cardClass
        return self
    }
    
    private var _sheetModel : [[String:Any]] = []
    /**
     Be the form of :
        let mockdata = [
           [
               kJJStaticSheetCardType : "TypeA",
               kJJStaticSheetCardModel : ["name": "noOdd"],
               kJJStaticSheetCardHeight : 60
           ],[
               kJJStaticSheetCardType : "TypeB",
               kJJStaticSheetCardModel : ["name": "noOdd"],
               kJJStaticSheetCardHeight : 60
           ],
        ],
     
        kJJStaticSheetCardType has to be registered in (func registCardType)
     */
    func addSheetModel(_ sheetModel : [[String:Any]]) {
        _sheetModel = sheetModel
        self._tableView.reloadData()
    }
    
    private var _cellItemEvent : JJCellItemEvent = {_,_,_ in}
    func handleEvents(_ eventCallback : @escaping JJCellItemEvent) {
        _cellItemEvent = eventCallback
    }
    
}

extension JJStaticSheetViewController {
    private func configTableView() {
        
        self.configTableViewDelegate()
        _tableView.delegate = self._tableViewDelegate
        _tableView.dataSource = self._tableViewDelegate
        self.view.addSubview(_tableView)
        _tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            _tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            _tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            _tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            _tableView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    private func configCellStructs() -> [String : JJCustomCellStruct] {
        var _cellStructs : [String:JJCustomCellStruct] = ["cell":JJCustomCellStruct(itemView: JJCustomCellItemView<Any>.self)]
        for (_cardTypeName, _cardClass) in _cardTypeMap {
            _cellStructs[_cardTypeName] = JJCustomCellStruct(itemView: _cardClass.self)
        }
        return _cellStructs
    }
    
    private func configTableViewDelegate() {
        
        let _cellStructs = self.configCellStructs()
        _tableViewDelegate = JJTableViewDelegate(_tableView)
//            .registWithCellStructs([
//                "aCell" : JJCustomCellStruct(itemView: My1Cell.self),
//                "bCell" : JJCustomCellStruct(itemView: My2Cell.self)
//            ])
            .registWithCellStructs(_cellStructs)
            .numOfSection(1)
            .numOfRowInSection({ [weak self](section) -> Int in
                return self?._sheetModel.count ?? 0
            })
            .cellHeightWithIndex({ [weak self](section, row) -> CGFloat in
                var resultHeight = CGFloat.leastNormalMagnitude
                guard let indexModel = self?._sheetModel[row] else {
                    return resultHeight
                }
                if let cellHeight = indexModel[kJJStaticSheetCardHeight] as? Int {
                    resultHeight = CGFloat(cellHeight)
                }else if let cellHeight = indexModel[kJJStaticSheetCardHeight] as? Double {
                    resultHeight = CGFloat(cellHeight)
                }else {
                    #if DEBUG
                    print("[JJLOG] You have no kJJStaticSheetCardHeight in \(row)")
                    #endif
                }
                
                return resultHeight
            })
            .cellReuseIdentifierWithIndex({ [weak self](section, row) -> String in
                guard let indexModel = self?._sheetModel[row] else {
                    return "cell"
                }
                guard let cellID = indexModel[kJJStaticSheetCardType] as? String else {
                    #if DEBUG
                    print("[JJLOG] You have no kJJStaticSheetCardType in \(row)")
                    #endif
                    return "cell"
                }
                return cellID
            })
            .modelWithIndex({ [weak self](section, row) -> Any in
                guard let indexModel = self?._sheetModel[row] else {
                    return ["error":"no model"]
                }
                guard let model = indexModel[kJJStaticSheetCardModel] else {
                    #if DEBUG
                    print("[JJLOG] You have no kJJStaticSheetCardModel in \(row)")
                    #endif
                    return ["error":"no model"]
                }
                return model
            })
            .select({ (section, row) in
                print("choose \(section), \(row)")
            })
            .addItemEventHandler({ [weak self](indexPath, eventType, data) in
                self?._cellItemEvent(indexPath, eventType, data)
            })
    }
}
