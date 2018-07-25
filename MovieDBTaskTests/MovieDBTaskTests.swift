//
//  MovieDBTaskTests.swift
//  MovieDBTaskTests
//
//  Created by Ahmed Zaghloul on 7/25/18.
//  Copyright © 2018 AhmedZaghloul. All rights reserved.
//

import XCTest
@testable import MovieDBTask

class MovieDBTaskTests: XCTestCase{

    var movie:Movie!
    
    override func setUp() {
        super.setUp()
        movie = Movie(data: ["id":nil,"video":true] as AnyObject)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMovie() {
        XCTAssertEqual(movie.id!, 0,"Wrong Default Value")
        XCTAssertEqual(movie.video!, true,"Wrong Value")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
