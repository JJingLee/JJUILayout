//
//  JJTableViewDelegate.swift
//  tableViewAbstract
//
//  Created by 李杰駿 on 2020/6/6.
//  Copyright © 2020 李杰駿. All rights reserved.
//

import UIKit
//MARK: - Delegate
class JJTableViewDelegate: NSObject {
    private var _numOfSections : Int = 0
    private var _numOfRowInSection : (Int)->Int = {_ in return 0}
    private var _cellIdentifier : (_ section : Int, _ row : Int)->String = {_,_ in return ""}
    private var _cellModel : (_ section : Int, _ row : Int)->Any = {_,_ in return [:]}
    private var _cellStructMap : [String:JJCustomCellStruct] = [:]
    private var _cellHeight : (_ section : Int, _ row : Int)->CGFloat = {_,_ in return 60}
    private var _selectForCell : (_ section : Int, _ row : Int)->Void = {_,_ in }
    private var _itemEventForwarder : JJCellItemEvent = {_,_,_ in }
    
    private weak var _tableView : UITableView?
    
    init(_ tableView : UITableView) {
        super.init()
        _tableView = tableView
        _tableView?.register(JJTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    //MARK: APIs
    /**
            - parameters
                - cellStructs : [cell_id, [cellStruct]]
     */
    open func registWithCellStructs(_ cellStructs : [String:JJCustomCellStruct])->Self {
        _cellStructMap = cellStructs
        for cellId in _cellStructMap.keys {
            _tableView?.register(JJTableViewCell.self, forCellReuseIdentifier: cellId)
        }
        return self
    }
    
    open func numOfSection(_ numOfSections : Int)->Self {
        _numOfSections = numOfSections
        return self
    }
    
    open func numOfRowInSection(_ callback : @escaping (Int)->Int)->Self {
        _numOfRowInSection = callback
        return self
    }
    
    /**
           - parameters
               - callback :  (section, row) -> cell_id
    */
    open func cellReuseIdentifierWithIndex(_ callback : @escaping (Int, Int)->String)->Self {
        _cellIdentifier = callback
        return self
    }
    
    /**
           - parameters
               - callback :  (section, row) -> model
    */
    open func modelWithIndex(_ callback : @escaping (Int, Int)->Any)->Self {
        _cellModel = callback
        return self
    }
    
    /**
           - parameters
               - callback :  (section, row) -> Height
    */
    open func cellHeightWithIndex(_ callback : @escaping (Int, Int)->CGFloat) -> Self {
        _cellHeight = callback
        return self
    }
    
    /**
           - parameters
               - callback :  (section, row)
    */
    func select(_ callback : @escaping (Int, Int)->Void)->Self {
        _selectForCell = callback
        return self
    }
    
    /**
        Get event from items. (indexPath:IndexPath, eventType:String, Data:Any)
     */
    func addItemEventHandler(_ handler : @escaping JJCellItemEvent)->Self {
        _itemEventForwarder = handler
        return self
    }
    
}

extension JJTableViewDelegate : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return _numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _numOfRowInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell_id = _cellIdentifier(indexPath.section,indexPath.row)
        let currentCellStruct = _cellStructMap[cell_id]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath) as! JJTableViewCell
        guard let itemType = currentCellStruct?.itemView else {
            return cell
        }
        if (cell._itemView == nil) {
            let itemViewClass = itemType.self// as NSObject.Type else { return cell }
            let itemView = itemViewClass.init()// as? JJCellItemViewProtocol else { return cell }
            itemView.forwardEvent { [weak self] (indexPath, eventType, Data) in
                self?._itemEventForwarder(indexPath, eventType, Data)
            }
            cell.addItemView(itemView)
        }
        cell._itemView?._indexPath = indexPath
        cell._itemView?.updateData("", _cellModel(indexPath.section, indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return _cellHeight(indexPath.section, indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _selectForCell(indexPath.section,indexPath.row)
    }
}

//MARK: - cell
class JJTableViewCell : UITableViewCell {
    
    var _itemView : JJCellItemViewProtocol?
    
    func addItemView(_ itemView : JJCellItemViewProtocol) {
        _itemView?.removeFromSuperview()
        _itemView = itemView
        self.contentView.addSubview(itemView)
        itemView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            itemView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            itemView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            itemView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            itemView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
        ])
    }
}
