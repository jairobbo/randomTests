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
    var collapsedStates = [String: Bool]() {
        didSet {
            if collapsedStates.count == AgeCategory.allValues.count {
                tableview.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableview.dataSource = self
        tableview.delegate = self
        
        personsModel = [
            Person(name: "Jairo", age: 36, category: .parent),
            Person(name: "Lise-Lotte", age: 33, category: .parent),
            Person(name: "Jascha", age: 0, category: .baby)
        ]
        
        for cat in AgeCategory.allValues {
            collapsedStates[cat.rawValue] = false
        }
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
        var personsInCategory: [Person] = personsModel.filter { switch $0.category {
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
    
    typealias CellInfo = (category: AgeCategory, isParentCell: Bool, person: Person?, localIndex: Int?)
    
    func cellType(at indexPath: IndexPath) -> CellInfo {
        var personStructure: [CellInfo] = []
        for cat in AgeCategory.allValues {
            personStructure.append((cat, true, nil, nil))
            if collapsedStates[cat.rawValue]! {
                let personsInCategory = personsIn(category: cat)
                for (index, person) in personsInCategory.enumerated() {
                    personStructure.append((cat, false, person, index))
                }
            }
        }
        return personStructure[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellInfo = cellType(at: indexPath)
        if cellInfo.isParentCell {
            guard let myCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as? CategoryCell else { return UITableViewCell() }
            myCell.label.text = cellInfo.category.rawValue
            myCell.selectionStyle = .none
            return myCell
        } else {
            guard let myCell = tableView.dequeueReusableCell(withIdentifier: "ChildCell") as? ChildCell else { return UITableViewCell() }
            myCell.label.text = "\(cellInfo.person!.name):  \(cellInfo.person!.age)"
            myCell.selectionStyle = .none
            return myCell
            
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellInfo = cellType(at: indexPath)
        guard cellInfo.isParentCell else { return }
        collapsedStates[cellInfo.category.rawValue] = !collapsedStates[cellInfo.category.rawValue]!
    }
}
