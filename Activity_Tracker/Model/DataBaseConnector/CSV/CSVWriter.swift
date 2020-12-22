//
//  CSVWriter.swift
//  HealthTrackerCalculator
//
//  Created by user166683 on 12/11/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import Foundation

protocol CSVWriterProtocol{
    func writeCSV(from array:[Dictionary<String, AnyObject>])
}

class CSVWriter: CSVWriterProtocol{
    
    
    func writeCSV(from array: [Dictionary<String, AnyObject>]) {
        if array.count > 0{
            print("begin write file at \(Date())")
            var csvString = "\("day"),\("balance_points"),\("balance_day")\n\n"
            for dct in array {
                csvString = csvString.appending("\(String(describing: dct["day"]!)) ,\(String(describing: dct["balance_points"]!)),\(String(describing: dct["balance_day"]!))\n")
            }

            let fileManager = FileManager.default
            do {
                let path = try fileManager.url(for: .applicationDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
                let fileURL = path.appendingPathComponent("ActivityBalance.csv")
                try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print(error.localizedDescription)
                print("error creating file")
            }
        }        
    }
}
