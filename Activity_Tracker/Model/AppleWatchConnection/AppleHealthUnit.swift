//
//  AppleHealthUnit.swift
//  Activity_Tracker
//
//  Created by user166683 on 12/13/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import Foundation

struct AppleHealthUnit{
    var sourceName,sourceVersion,device,type,unit,creationDate,startDate,endDate,value,day : String
}

struct AppleHealthValue{
    var day, start, end: Date
    var value: Int
    var length: Int { return Int(DateInterval(start: self.start, end: self.end).duration) }
    var nextTimeInterval: Int?
    var previousTimeInterval: Int?
}
