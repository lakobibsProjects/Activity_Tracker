//
//  AppleHealthUnit.swift
//  HealthTrackerCalculator
//
//  Created by user166683 on 12/13/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import Foundation

///Struct that descript structure of item from .csv file of Apple Health
struct AppleHealthUnit{
    var sourceName,sourceVersion,device,type,unit,creationDate,startDate,endDate,value,day : String
}

///Struct that parse AppleHealthUnit for calculation
struct AppleHealthValue{
    var day, start, end: Date
    var value: Int
    var length: Int {
        if self.start < self.end{
             return Int(DateInterval(start: self.start, end: self.end).duration)
        }else{
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"            
            print("Corrupted data: start(\(dateFormatter.string(from: self.start))) after end(\(dateFormatter.string(from: self.end)))")
            return 0
        }
    }
    var nextTimeInterval: Int?
    var previousTimeInterval: Int?
}
