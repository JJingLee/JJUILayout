# JJUILayout

## Background
To Boost Develop pace for iOS basic components.

## Current Support
- UITableView

## Will Support In Future
- UICollectionView

## Code

#### Item view for cell
<pre><code>

//with type [String:Any]
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

//with type cell2Model
struct cell2Model {
    var name : String?
}
class My2Cell: JJCustomCellItemView<cell2Model> {
    let _label : UILabel = UILabel()
    
    override func initUI() {
        super.initUI()
        _label.textColor = UIColor.red
        _label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(_label)
        self.addConstraints([
            _label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            _label.leftAnchor.constraint(equalTo: self.leftAnchor),
        ])
        
    }
    
    override func updateUI(_ data: cell2Model) {
        super.updateUI(data)
        _label.text = data.name
    }
    
}
</code></pre>

#### Delegate
<pre><code>
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
</code></pre>
