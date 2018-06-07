//
//  testTests.swift
//  testTests
//
//  Created by Bambang Oetomo, Jairo (NL - Amsterdam) on 06/06/2018.
//  Copyright © 2018 Bambang Oetomo, Jairo (NL - Amsterdam). All rights reserved.
//

import XCTest
@testable import test

class testTests: XCTestCase {
    
    var vc: ViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: self.classForCoder))
        vc = storyboard.instantiateViewController(withIdentifier: "VC") as! ViewController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDecodeJSON() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let jsonString = """
            {
                "persons":
                        [
                            {
                            "name": "Jairo",
                            "age": 36
                            },
                            {
                            "name": "Sarah",
                            "age": 29
                            }
                        ]
            }
        """
        let data = jsonString.data(using: .utf8)
        let personsArray: [Person] = vc.getObjectsfrom(data: data!, with: "persons")!
        XCTAssert(!personsArray.isEmpty)
    }
    
    func testEncodeJSON() {
        let objects = [
            Person(name: "Jairo", age: 36),
            Person(name: "Lise-Lotte", age: 33)
        ]
        let data = vc.encodeJsonfor(objects: objects)
        print(String(data: data, encoding: .utf8))
        XCTAssert(data != nil)
    }
    
}
