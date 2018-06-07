//
//  ViewController.swift
//  test
//
//  Created by Bambang Oetomo, Jairo (NL - Amsterdam) on 06/06/2018.
//  Copyright © 2018 Bambang Oetomo, Jairo (NL - Amsterdam). All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
