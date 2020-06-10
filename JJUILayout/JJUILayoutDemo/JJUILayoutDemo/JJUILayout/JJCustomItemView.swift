//
//  JJCustomItemView.swift
//  tableViewAbstract
//
//  Created by 李杰駿 on 2020/6/6.
//  Copyright © 2020 李杰駿. All rights reserved.
//

import UIKit

//MARK: - itemView
protocol JJCellItemViewProtocol : UIView {
    func updateData(_ event : String?, _ data : Any?)
}
protocol JJCellItemViewLayoutProtocol {
    associatedtype DataSourceT
    func initUI()
    func updateUI(_ data: DataSourceT)
}

class JJCustomCellItemView<DataT> : UIView, JJCellItemViewLayoutProtocol {
    typealias DataSourceT = DataT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initUI() {
        //need override
    }
    func updateUI(_ data: DataT) {
        //need override
    }
}

extension JJCustomCellItemView : JJCellItemViewProtocol {
    func updateData(_ event: String?, _ data: Any?) {
        guard let _data = data as? DataT else {
            return
        }
        self.updateUI(_data)
    }
}



struct JJCustomCellStruct {
    var itemView : JJCellItemViewProtocol.Type? //must confirm tableItemView
}
