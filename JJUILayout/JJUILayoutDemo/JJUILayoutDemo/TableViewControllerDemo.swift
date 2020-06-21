//
//  ViewController.swift
//  tableViewAbstract
//
//  Created by 李杰駿 on 2020/6/4.
//  Copyright © 2020 李杰駿. All rights reserved.
//

import UIKit

class TableViewControllerDemo: UIViewController {
    
    let _tableView : UITableView = UITableView()
    var _tableDelegate : JJTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        // Do any additional setup after loading the view.
    }

    private func configTableView() {
        configTableViewDelegate()
        configTableViewLayout()
    }
    
    private func configTableViewDelegate() {
        _tableDelegate = JJTableViewDelegate(_tableView)
                        .registWithCellStructs([
                            "aCell" : JJCustomCellStruct(itemView: My1Cell.self),
                            "bCell" : JJCustomCellStruct(itemView: My2Cell.self)
                        ])
                        .numOfSection(1)
                        .numOfRowInSection({ (section) -> Int in
                            return 50
                        })
                        .cellHeightWithIndex({ (section, row) -> CGFloat in
                            return row%3==0 ? 50 : 80
                        })
                        .cellReuseIdentifierWithIndex({ (section, row) -> String in
                            return row%3==0 ? "bCell" : "aCell"
                        })
                        .modelWithIndex({ (section, row) -> Any in
                            if (row%3==0) {
                                return cell2Model(name: row%2==0 ? "noOdd" : "odd")
                            }
                            return ["name": row%2==0 ? "noOdd" : "odd"]
                        })
                        .select({ (section, row) in
                            print("choose \(section), \(row)")
                        })
        
        _tableView.delegate = _tableDelegate
        _tableView.dataSource = _tableDelegate
    }
    
    private func configTableViewLayout() {
        self._tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self._tableView)
        self.view.addConstraints([
            self._tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self._tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self._tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            self._tableView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)

        ])
    }
    
}

class My1Cell: JJCustomCellItemView<[String:Any]> {
    let _label : UILabel = UILabel()
    
    override func initUI() {
        super.initUI()
        _label.textColor = UIColor.black
        _label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(_label)
        self.addConstraints([
            _label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            _label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
    }
    
    override func updateUI(_ data: [String : Any]) {
        super.updateUI(data)
        _label.text = data["name"] as? String
    }
    
}

struct cell2Model {
    var name : String?
}
class My2Cell: JJCustomCellItemView<cell2Model> {
    let _label : UILabel = UILabel()
    let _button : UIButton = {
        let _btn = UIButton()
        _btn.setTitle("tap", for: .normal)
        _btn.setTitleColor(UIColor.red, for: .normal)
        return _btn
    }()
    
    @objc func buttonTap(_ sender : Any) {
        self.sendEvent(self._indexPath, "buttonTap","got it ?")
    }
    
    override func initUI() {
        super.initUI()
        _label.textColor = UIColor.red
        _label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(_label)
        self.addConstraints([
            _label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            _label.leftAnchor.constraint(equalTo: self.leftAnchor),
        ])
        
        _button.addTarget(self, action: #selector(self.buttonTap(_:)), for: .touchUpInside)
        _button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(_button)
        self.addConstraints([
            _button.widthAnchor.constraint(equalToConstant: 60),
            _button.heightAnchor.constraint(equalToConstant: 44),
            _button.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            _button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
    }
    
    override func updateUI(_ data: cell2Model) {
        super.updateUI(data)
        _label.text = data.name
    }
    
}








