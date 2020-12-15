//
//  CSVReader.swift
//  Activity_Tracker
//
//  Created by user166683 on 12/11/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import Foundation

protocol  CSVReaderProtocol {
    
    func readCSV(from file: URL) -> String
}

protocol AppleHealthCSVProvider{
    func getHealthUnitArray() -> [AppleHealthUnit]
}

struct CSVReader: CSVReaderProtocol, AppleHealthCSVProvider{
    private let path = "/Users/user166683/Desktop/Projects/Activity_Tracker/Activity_Tracker/Resources/mobile_test_inputs.csv"
    
    
    func readCSV(from file: URL) -> String {
        do {
           return try String(contentsOf: file, encoding: String.Encoding.utf8)
        } catch {
            print(error.localizedDescription)
            //error handling
        }
        //TODO: update reading function
        return ""
    }
    
    private func readAppleHealth(from file: URL) -> [AppleHealthUnit] {
        let content = readCSV(from: file)
        var lines:[String] = content.components(separatedBy: "\n")
        lines.remove(at: 0)
        var units = [AppleHealthUnit]()
        for line in lines{
            let lineUnits = line.components(separatedBy: ",")
            let length = lineUnits.count - 1
            var device = ""
            if lineUnits.count >= 2{
                for unit in 2...lineUnits.count{
                    if lineUnits[unit] == "StepCount"{
                        break
                    }else{
                        device = device + lineUnits[unit]
                    }
                    
                }
                let unit = AppleHealthUnit(sourceName: lineUnits[0],
                                           sourceVersion: lineUnits[1],
                                           device: device,
                                           type: lineUnits[length - 6],
                                           unit: lineUnits[length - 5],
                                           creationDate: lineUnits[length - 4],
                                           startDate: lineUnits[length - 3],
                                           endDate: lineUnits[length - 2],
                                           value: lineUnits[length - 1],
                                           day: lineUnits[length])
                units.append(unit)
            }
        }
        
        return units
    }
    
    func getHealthUnitArray() -> [AppleHealthUnit]{
        return readAppleHealth(from: URL(fileURLWithPath: path))
    }
}
