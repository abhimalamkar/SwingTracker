//
//  SwingTrackerTests.swift
//  SwingTrackerTests
//
//  Created by Abhijeet Malamkar on 9/11/19.
//  Copyright © 2019 Abhijeet Malamkar. All rights reserved.
//

import XCTest
@testable import SwingTracker

class SwingTrackerTests: XCTestCase {

    var swingTracker:SwingTracker?
    var winLength = 10
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        swingTracker = SwingTracker(fromFile: "latestSwing.csv")
    }

    func testSearchContinuityAboveValue(){
        if let data = swingTracker?.data?.map({($0.accelerometerData?.vector3.x)!}) {
            
            let threshold = 0.0
            
            let index = swingTracker?.searchContinuityAboveValue(data: data, indexBegin: 0, indexEnd: 30, threshold: threshold, winLength: winLength)
            
            print(index)
            
            assert(index != nil)
            
            if let ind = index {
                for i in ind...ind + winLength - 1 {
                    print(swingTracker?.getData(atIndex: i)?.accelerometerData?.vector3.x)
                }
                
                assert((swingTracker?.getData(atIndex: ind)?.accelerometerData?.vector3.x)! > threshold)
            }
        }
    }
    
    func testBackSearchContinuityWithinRange(){
        if let data = swingTracker?.data?.map({($0.accelerometerData?.vector3.x)!}) {
            
            let index = swingTracker?.backSearchContinuityWithinRange(data: data, indexBegin: 38, indexEnd: 0, thresholdLo: 0, thresholdHi: 1, winLength: winLength)
            
            print(index)
            
            if let ind = index {
                for i in stride(from: ind, through: ind - (winLength - 1), by: -1) {
                    print(swingTracker?.getData(atIndex: i)?.accelerometerData?.vector3.x)
                }
                
                assert((swingTracker?.getData(atIndex: ind)?.accelerometerData?.vector3.x)! > 0.0 && (swingTracker?.getData(atIndex: ind)?.accelerometerData?.vector3.x)! < 1.0)
            }
        }
    }
    
    func testSearchContinuityAboveValueTwoSignals(){
        if let data = swingTracker?.data?.map({($0.accelerometerData?.vector3.x)!}) {
            
            let index = swingTracker?.searchContinuityAboveValueTwoSignals(data1: data, data2: data, indexBegin: 0, indexEnd: 30, threshold1: 0, threshold2: 0, winLength: winLength)
            
            
            if let ind = index {
                for i in ind...ind + winLength - 1 {
                    print(swingTracker?.getData(atIndex: i)?.accelerometerData?.vector3.x)
                }
                
                assert((swingTracker?.getData(atIndex: ind)?.accelerometerData?.vector3.x)! > 0.0)
            }
        }
    }
    
    func testSearchMultiContinuityWithinRange(){
        if let data = swingTracker?.data?.map({($0.accelerometerData?.vector3.x)!}) {
            
            let index = swingTracker?.searchMultiContinuityWithinRange(data: data, indexBegin: 0, indexEnd: 30, thresholdLo: 0, thresholdHi: 1, winLength: winLength)
            
            if let ind = index?.indexBegin {
                for i in ind...ind + winLength - 1 {
                    print(swingTracker?.getData(atIndex: i)?.accelerometerData?.vector3.x)
                }
                
                assert((swingTracker?.getData(atIndex: ind)?.accelerometerData?.vector3.x)! > 0.0 && (swingTracker?.getData(atIndex: ind)?.accelerometerData?.vector3.x)! < 1.0)
            }
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            testSearchContinuityAboveValue()
        }
    }

}
