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
    
    func check(data:[Double],indexBegin:Int,indexEnd:Int,threshold:Double,
               winLength:Int,isReversed:Bool) -> Int? {
        
        if !isReversed ?
            indexEnd >= data.count || indexBegin < 0 || indexEnd - indexBegin < winLength - 1 :
            indexBegin >= data.count || indexEnd < 0 || indexBegin - indexEnd < winLength - 1 {
            return nil
        }
        
        if threshold.isLess(than: data[indexBegin]) {
            for j in 1...winLength - 1  {
                if data[indexBegin+j].isLess(than: threshold) {
                    return nil
                }
            }
            return indexBegin
        } else {
            return check(data: data, indexBegin: !isReversed ? indexBegin + 1 : indexBegin - 1, indexEnd: indexEnd, threshold: threshold, winLength: winLength, isReversed: isReversed)
        }
    }
    
    func searchContinuityAboveValue(data:[Double],indexBegin:Int,indexEnd:Int,threshold:Double,
                                    winLength:Int) -> Int? {
        
//        if indexEnd >= data.count || indexBegin < 0 {
//            return nil
//        }
//
//        for i in indexBegin...indexEnd {
//            if threshold.isLess(than: data[i]) {
//                for j in 1...winLength - 1  {
//                    if data[i+j].isLess(than: threshold) {
//                        return nil
//                    }
//                }
//                return i
//            }
//        }
//
//        return nil
        
        return check(data: data, indexBegin: indexBegin, indexEnd: indexEnd, threshold: threshold, winLength: winLength, isReversed: false)
    }
    
    func backSearchContinuityWithinRange(data:[Double],indexBegin:Int,indexEnd:Int,
                                         thresholdLo:Double,thresholdHi:Double,winLength:Int) -> Int? {
        
//        if indexBegin >= data.count || indexEnd < 0 {
//            return nil
//        }
//
//        for i in stride(from: indexBegin, through: indexEnd, by: -1) {
//            if thresholdLo.isLess(than: data[i]) && data[i].isLess(than: thresholdHi) {
//                for j in 1...winLength - 1 {
//                    if data[i-j].isLess(than: thresholdLo) || thresholdHi.isLess(than: data[i-j]) {
//                        return nil
//                    }
//                }
//
//                return i
//            }
//        }
//
//        return nil
        
        return check(data: data, indexBegin: indexBegin, indexEnd: indexEnd, threshold: thresholdLo, winLength: winLength, isReversed: true)
    }
    
    func searchContinuityAboveValueTwoSignals(data1:[Double],data2:[Double],indexBegin:Int,
                                              indexEnd:Int,threshold1:Double,threshold2:Double,
                                              winLength:Int) -> Int? {
        
        if indexEnd >= data1.count || indexBegin < 0 || indexEnd >= data2.count {
            return nil
        }
        
        for i in indexBegin...indexEnd {
            if threshold1.isLess(than: data1[i]) && threshold2.isLess(than: data2[i]) {
                for j in 1...winLength - 1  {
                    if data1[i + j].isLess(than: threshold1) && data2[i + j].isLess(than: threshold2) {
                        return nil
                    }
                }
                return i
            }
        }
        
        return nil
    }
    
    func searchMultiContinuityWithinRange(data:[Double], indexBegin:Int, indexEnd:Int,
                                          thresholdLo:Double, thresholdHi:Double, winLength:Int) -> (indexBegin:Int, indexEnd:Int)? {
        
        if indexEnd >= data.count || indexBegin < 0 {
            return nil
        }
        
        for i in indexBegin...indexEnd {
            if thresholdLo.isLess(than: data[i]) && data[i].isLess(than: thresholdHi) {
                var j = 1
                while thresholdLo.isLess(than: data[i+j]) && data[i+j].isLess(than: thresholdHi) {
                    j += 1
                }
                
                return j < winLength ? nil : (i, i + j - 1)
            }
        }
        
        return nil
    }
}
