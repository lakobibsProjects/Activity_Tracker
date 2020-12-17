//
//  AppleHealthService.swift
//  HealthTrackerCalculator
//
//  Created by user166683 on 12/12/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import Foundation

///Protocol that describe working with AppleHelath
protocol AppleHealthServiceProtocol{
    var reader: AppleHealthProvider { get }
    
    func writeData(_: [(String, AnyObject)])
    func getData() -> [AppleHealthValue]
}


///Class for reading Apple Health data and writing results
class AppleHealthService: AppleHealthServiceProtocol{
    var reader: AppleHealthProvider = CSVReader()
    private var appleHealthValueArray: [AppleHealthValue] = []
    private var thread = DispatchQueue.global(qos: .background)
    
    //MARK: - AppleHealthServiceProtocol Functions
    /// Method, that returns balance points for complete period of observation
    ///
    /// - Returns: Array of AppleHealthValue
    func getData() -> [AppleHealthValue] {
        updateInfo()
        return appleHealthValueArray
    }
    
    /// Write data to .csv file
    ///
    /// - Parameter data to write
    func writeData(_: [(String, AnyObject)]) {
        
    }
    
    //MARK: - Support Functions
    ///Get new data and parse to appleHealthValueArray
    private func updateInfo() {
        thread.async{
            self.appleHealthValueArray = self.reader.getHealthUnitArray().map({
                let startEndDateFormatter = DateFormatter()
                startEndDateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                startEndDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                return AppleHealthValue(day: dateFormatter.date(from: $0.day)!,
                                        start: startEndDateFormatter.date(from: $0.startDate)!,
                                        end: startEndDateFormatter.date(from: $0.endDate)!,
                                        value: Int($0.value)!)
            })
            self.setIntervals()
        }
    }
    
    /// set nextTimeInterval and previousTimeInterval for appleHealthValueArray
    private func setIntervals(){
        thread.async{
            for i in 0..<self.appleHealthValueArray.count - 1{
                if self.appleHealthValueArray[i].day == self.appleHealthValueArray[i + 1].day &&
                    Calendar.current.component(.hour, from: self.appleHealthValueArray[i].start) == Calendar.current.component(.hour, from: self.appleHealthValueArray[i + 1].start){
                    if self.appleHealthValueArray[i].end < self.appleHealthValueArray[i + 1].start{
                        self.appleHealthValueArray[i].nextTimeInterval = Int(DateInterval(start: self.appleHealthValueArray[i].end, end: self.appleHealthValueArray[i + 1].start).duration)
                    }
                }
                if i > 0{
                    if self.appleHealthValueArray[i - 1].day == self.appleHealthValueArray[i].day &&
                        Calendar.current.component(.hour, from: self.appleHealthValueArray[i].start) == Calendar.current.component(.hour, from: self.appleHealthValueArray[i - 1].start){
                        if self.appleHealthValueArray[i - 1].end < self.appleHealthValueArray[i].start{
                            self.appleHealthValueArray[i].previousTimeInterval = Int(DateInterval(start: self.appleHealthValueArray[i - 1].end, end: self.appleHealthValueArray[i].start).duration)
                        }
                    }
                    
                }
            }
        }
    }
}
