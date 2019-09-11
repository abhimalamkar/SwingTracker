//
//  StringExtenstion.swift
//  SwingTracker
//
//  Created by Abhijeet Malamkar on 9/10/19.
//  Copyright © 2019 Abhijeet Malamkar. All rights reserved.
//

import Foundation

public extension String {
    
    func readDataFromFile() -> String? {
        
        let splits = self.split(separator: ".")
        if splits.count < 2 {
            #if DEBUG
            print("Wrong file name")
            #endif
            return nil
        }
        let file = String(splits[0])
        let fileType = String(splits[1])
        
        guard let filepath = Bundle.main.path(forResource: file, ofType: fileType)
            else {
                return nil
        }
        
        do {
            let contents = try String(contentsOfFile: filepath)
            return contents
        } catch {
            #if DEBUG
            print ("File Read Error")
            #endif
            return nil
        }
    }
    
    func toCSV () -> [[String]] {
        var data = self
        var result: [[String]] = []
        
        //cleaning the data
        data = data.replacingOccurrences(of: "\r",with: "\n")
        data = data.replacingOccurrences(of: "\n\n", with: "\n")
        
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
    
}
