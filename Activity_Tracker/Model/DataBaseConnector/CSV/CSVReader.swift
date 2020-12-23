//
//  CSVReader.swift
//  HealthTrackerCalculator
//
//  Created by user166683 on 12/11/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import Foundation

/// A protocol that establishes a way for read .csv file
protocol  CSVReaderProtocol {
    mutating func readCSV(from file: URL) -> String
}

/// A protocol that return parsed result of readed file
protocol AppleHealthProvider{
    mutating func getHealthUnitArray() -> [AppleHealthUnit]
}

/// A class that read .csv file and parse it
struct CSVReader: CSVReaderProtocol, AppleHealthProvider{
    //absolute path
    //private let path = "/Users/user166683/Desktop/Projects/Activity_Tracker/Activity_Tracker/Resources/mobile_test_inputs.csv"
    //relative path
    private let path = Bundle.main.bundleURL.appendingPathComponent("Activity_Tracker/Resources/mobile_test_inputs.csv")
    private var csvString: String?
    
    //MARK: - CSVReaderProtocol Methods
    /// Read .csv file
    ///
    /// - Parameter file: url of file, that reads
    /// - Returns:content of file as String
    mutating func readCSV(from file: URL) -> String {
        if let csv = csvString{
            return csv
        } else{
            do {
                csvString =  try String(contentsOf: file, encoding: String.Encoding.utf8)
                return csvString!
            } catch {
                print(error.localizedDescription)
                //error handling
            }
        }
        //TODO: update reading function
        return ""
        
    }
    
    //MARK: -AppleHealthProvider Methods
    /// Return result of parse data
    ///
    /// - Returns: array of AppleHealthUnit
    mutating func getHealthUnitArray() -> [AppleHealthUnit]{
        return readAppleHealth(from: path)
    }
    
    //MARK: - Support Functions
    /// Read and parse .csv file
    ///
    /// - Parameter file: url of file, that reads
    /// - Returns:content of file as AppleHealthUnit
    private mutating func readAppleHealth(from file: URL) -> [AppleHealthUnit] {
        let content = readCSV(from: file)
        var lines:[String] = content.components(separatedBy: "\n")
        lines.remove(at: 0)
        var units = [AppleHealthUnit]()
        for line in lines{
            let lineUnits = line.components(separatedBy: ",")
            let length = lineUnits.count - 1
            var device = ""
            var day = ""
            if lineUnits.count >= 2{
                for unit in 2...lineUnits.count{
                    if lineUnits[unit] == "StepCount"{
                        break
                    }else{
                        device = device + lineUnits[unit]
                    }
                    
                }
                day = lineUnits[length]
                day.removeSubrange(day.index(day.endIndex, offsetBy: -1)..<day.endIndex)
                let unit = AppleHealthUnit(sourceName: lineUnits[0],
                                           sourceVersion: lineUnits[1],
                                           device: device,
                                           type: lineUnits[length - 6],
                                           unit: lineUnits[length - 5],
                                           creationDate: lineUnits[length - 4],
                                           startDate: lineUnits[length - 3],
                                           endDate: lineUnits[length - 2],
                                           value: lineUnits[length - 1],
                                           day: day)
                units.append(unit)
            }
        }
        return units
    }
    
    
}
