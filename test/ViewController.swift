//
//  ViewController.swift
//  test
//
//  Created by Bambang Oetomo, Jairo (NL - Amsterdam) on 06/06/2018.
//  Copyright © 2018 Bambang Oetomo, Jairo (NL - Amsterdam). All rights reserved.
//

import UIKit

enum AgeCategory: String, Codable {
    case parent
    case child
    case baby
    static let allValues: [AgeCategory] = [.parent, .child, .baby]
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    var personsModel: [Person] = []
    var collapsedStates = [String: Bool]()
    var indexPathsOfCellToPop: [IndexPath] = []
    var cellStructure: [CellInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for cat in AgeCategory.allValues {
            collapsedStates[cat.rawValue] = false
        }
        
        for i in 0...29 {
            personsModel.append(Person(name: "person\(i)", age: 1, category: .parent))
        }
        
        for i in 0...29 {
            personsModel.append(Person(name: "person\(i)", age: 1, category: .child))
        }
        
        for i in 0...29 {
            personsModel.append(Person(name: "person\(i)", age: 1, category: .baby))
        }
        
        cellStructure = makeCellStructure()
        
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorStyle = .none
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func getObjectsfrom<type: Codable>(data: Data, with key: String) -> [type]? {
        let decoder = JSONDecoder()
        let dictWithArray = try! decoder.decode([String: [type]].self, from: data)
        guard let objectArray = dictWithArray[key] else { return nil }
        return objectArray
    }
    
    public func encodeJsonfor<type: Codable>(objects: [type]) -> Data {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(objects)
        return data
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func personsIn(category: AgeCategory) -> [Person] {
        let personsInCategory: [Person] = personsModel.filter { switch $0.category {
        case category:
            return true
        default:
            return false
            }
        }
        return personsInCategory
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalRows = AgeCategory.allValues.count
        for cat in AgeCategory.allValues {
            if collapsedStates[cat.rawValue]! {
                totalRows += personsIn(category: cat).count
            }
        }
        return totalRows
    }
    
    typealias CellInfo = (category: AgeCategory, isParentCell: Bool, isCollapsed: Bool, person: Person?, localIndex: Int?)
    
    func makeCellStructure() -> [CellInfo] {
        var personStructure: [CellInfo] = []
        for cat in AgeCategory.allValues {
            if collapsedStates[cat.rawValue]! {
                personStructure.append((category: cat, isParentCell: true, isCollapsed: true, person: nil, localIndex: nil))
            } else {
                personStructure.append((category: cat, isParentCell: true, isCollapsed: false, person: nil, localIndex: nil))
            }
            if collapsedStates[cat.rawValue]! {
                let personsInCategory = personsIn(category: cat)
                for (index, person) in personsInCategory.enumerated() {
                    personStructure.append((cat, false, false, person, index))
                }
            }
        }
        return personStructure
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellInfo = cellStructure[indexPath.row]
        if cellInfo.isParentCell {
            guard let myCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as? CategoryCell else { return UITableViewCell() }
            myCell.label.text = cellInfo.category.rawValue
            myCell.selectionStyle = .none
            if cellInfo.isCollapsed {
                myCell.iconImage.image = UIImage(named: "minus")
            } else {
                myCell.iconImage.image = UIImage(named: "plus")
            }
            return myCell
        } else {
            guard let myCell = tableView.dequeueReusableCell(withIdentifier: "ChildCell") as? ChildCell else { return UITableViewCell() }
            myCell.label.text = "\(cellInfo.person!.name):  \(cellInfo.person!.age)"
            myCell.selectionStyle = .none
            if indexPathsOfCellToPop.contains(indexPath) {
                myCell.dotImage.transform = CGAffineTransform(scaleX: 0, y: 0)
            }
            return myCell
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: false)
        let cellInfo = cellStructure[indexPath.row]
        guard cellInfo.isParentCell else { return }
        
        let cell = tableview.cellForRow(at: indexPath) as! CategoryCell
        
        
        collapsedStates[cellInfo.category.rawValue] = !collapsedStates[cellInfo.category.rawValue]!
        cellStructure = makeCellStructure()
        
        var indexPaths: [IndexPath] = []
        let numberOfItems = personsIn(category: cellInfo.category).count
        for i in 1...numberOfItems {
            indexPaths.append(IndexPath(row: indexPath.row + i, section: 0))
        }
        indexPathsOfCellToPop = indexPaths
        
        tableView.performBatchUpdates({
            if collapsedStates[cellInfo.category.rawValue]! {
                tableview.insertRows(at: indexPaths, with: .fade)
                cell.iconImage.image = UIImage(named: "minus")
            } else {
                tableView.deleteRows(at: indexPaths, with: .fade)
                cell.iconImage.image = UIImage(named: "plus")
            }
        }) { (finished) in
            if finished {
                print("batch done")
                let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
                    guard let ip = self.indexPathsOfCellToPop.first else { timer.invalidate(); self.indexPathsOfCellToPop = []; return }
                    guard let cell = tableView.cellForRow(at: ip) as? ChildCell else {
                            self.indexPathsOfCellToPop.remove(at: 0)
                            return }
                    cell.pop()
                    self.indexPathsOfCellToPop.remove(at: 0)
                })
                timer.fire()
            }
        }
    }
}
