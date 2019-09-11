//
//  API.swift
//  SwingTracker
//
//  Created by Abhijeet Malamkar on 9/11/19.
//  Copyright © 2019 Abhijeet Malamkar. All rights reserved.
//

import Foundation

enum DataPoints:Int {
    case timestamp = 0, ax, ay, az, wx, wy, wz
}

struct DimentionalData {
    var vector3:(x:Double,y:Double,z:Double)
}

struct SwingData {
    //
    var timestep:TimeInterval?
    var accelerometerData:DimentionalData?
    var gyroscopeData:DimentionalData?
}

class SwingTracker {
    var data:[SwingData]?
    
    init() {
        
    }
    
    init(fromFile:String) {
        self.data = parseSwingDataFromCsv(data: fromFile.readDataFromFile()?.toCSV() ?? [[]])
    }
    
    func getData(atIndex:Int) -> SwingData? {
        if atIndex > 0 && self.data != nil && atIndex < self.data!.count {
            return self.data?[atIndex]
        }
        else {
            print("index not found or invalid index")
            return nil
        }
    }
    
    func parseSwingDataFromCsv(data:[[String]]) -> [SwingData]? {
        var swingData:[SwingData] = []
        for row in data {
            if let time = Double(row[DataPoints.timestamp.rawValue]),
                let ax = Double(row[DataPoints.ax.rawValue]),
                let ay = Double(row[DataPoints.ay.rawValue]),
                let az = Double(row[DataPoints.az.rawValue]),
                let wx = Double(row[DataPoints.wx.rawValue]),
                let wy = Double(row[DataPoints.wy.rawValue]),
                let wz = Double(row[DataPoints.wz.rawValue]){
                
                let timestamp = TimeInterval(exactly: time)
                let accelerometerData = DimentionalData(vector3: (x: ax, y: ay, z: az))
                let gyroscopeData = DimentionalData(vector3: (x: wx, y: wy, z: wz))
                swingData.append(SwingData(timestep: timestamp, accelerometerData: accelerometerData, gyroscopeData: gyroscopeData))
            }
        }
        
        return swingData
    }
    
    func searchContinuityAboveValue(data:Double,indexBegin:Int,indexEnd:Int,threshold:Double,
                                   winLength:Int) -> Int? {
        if let data = self.data {
            for i in indexBegin...indexEnd {
                print(i)
                if let accX = data[i].accelerometerData?.vector3.x {
                    if threshold.isLess(than: accX) {
                        return i
                    }
                }
            }
        }
        
        return nil
    }
    
    func backSearchContinuityWithinRange(data:Double,indexBegin:Int,_ indexEnd:Int,
                                        _ thresholdLo:Double,_ thresholdHi:Double,_ winLength:Int) {
        
    }
    
    func searchContinuityAboveValueTwoSignals(_ data1:Double,_ data2:Double,_ indexBegin:Int,
                                             _ indexEnd:Int,_ threshold1:Double,_ threshold2:Double,
                                             _ winLength:Int) {
        
    }
    
    func searchMultiContinuityWithinRange(data:Double, indexBegin:Int, indexEnd:Int,
                                          thresholdLo:Double, thresholdHi:Double, winLength:Int) {
        
    }
}




