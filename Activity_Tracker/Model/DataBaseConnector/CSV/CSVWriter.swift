//
//  CSVWriter.swift
//  HealthTrackerCalculator
//
//  Created by user166683 on 12/11/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import Foundation
/// A protocol that establishes a way for write into .csv file
protocol CSVWriterProtocol{
    func writeCSV(from array:[Dictionary<String, AnyObject>])
}

/// A class that  write data into .csv file
class CSVWriter: CSVWriterProtocol{
    private var thread = DispatchQueue.global(qos: .background)
    
    //MARK: - CSVWriterProtocol Methods
    /// Write into .csv file
    ///
    /// - Parameter array: writing data
    func writeCSV(from array: [Dictionary<String, AnyObject>]) {
        thread.async {
            if array.count > 0{
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
                }
                print("Write balance data into file successfully at \(Date())")
            }
        }
        
    }
}
