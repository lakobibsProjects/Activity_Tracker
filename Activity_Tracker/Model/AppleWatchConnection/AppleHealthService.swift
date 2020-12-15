//
//  AppleHealthService.swift
//  Activity_Tracker
//
//  Created by user166683 on 12/12/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import Foundation

protocol AppleHealthServiceProtocol{
    var reader: AppleHealthCSVProvider { get }
    var balacePoint: [Date: Int]? { get }
    var balanceDay: [Date: Int]? { get }
    
    func updateInfo()
    func writeData(_: [Dictionary<String, AnyObject>])
    func balancePointCalculation()
    func balanceDayCalculation()
}


class AppleHealthService: AppleHealthServiceProtocol{
    var reader: AppleHealthCSVProvider = CSVReader()
    var balacePoint: [Date : Int]? { return getBalacePoints() }
    var balanceDay: [Date : Int]? { return getDayBalance() }
    private var appleHealthValueArray: [AppleHealthValue] = []
    private var dateSet: Set<Date> { return Set(appleHealthValueArray.map({ return $0.day }))}
    
    init() {
        self.updateInfo()
        
    }
    
    func updateInfo() {
        self.appleHealthValueArray = reader.getHealthUnitArray().map({
            let startEndDateFormatter = DateFormatter()
            startEndDateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            startEndDateFormatter.dateFormat = "yyyy-MM-d HH:mm:ss"
            let dateFormatter = DateFormatter()
            startEndDateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            startEndDateFormatter.dateFormat = "yyyy-MM-d"
            
            return AppleHealthValue(day: dateFormatter.date(from: $0.day)!,
                                    start: startEndDateFormatter.date(from: $0.startDate)!,
                                    end: startEndDateFormatter.date(from: $0.endDate)!,
                                    value: Int($0.value)!)
        })
        setIntervals()
    }
    
    func writeData(_: [Dictionary<String, AnyObject>]) {
        
    }
    
    func balancePointCalculation() {
    
    }
    
    func balanceDayCalculation() {
        
    }
    
    private func getBalacePoints() -> [Date: Int]{
        var result = [Date: Int]()
        for value in dateSet{
            let dayData = mergeValues(appleHealthValueArray.filter({$0.day == value}))
            for i in 0...23{
                let hourData = dayData.filter({Calendar.current.component(.hour, from: $0.start) == i})
                for item in 0...hourData.count{
                    let components = Calendar.current.dateComponents([.second, .minute], from: hourData[item].start)
                    let comp = DateComponents(minute: -components.minute!, second: -components.second!)
                    let date = Calendar.current.date(byAdding: comp, to: hourData[item].start)!

                    if hourData[item].length > 180{
                        if result[date] == nil{
                            result[date] = 1
                        } else {
                            if hourData[item].previousTimeInterval ?? 0 >= 2280{
                                result[date] = 2
                            }
                        }
                    }
                }
            }
        }
       
        return result
    }
    
    private func getDayBalance() -> [Date: Int]{
        var result = [Date: Int]()
        let data = getBalacePoints()
        
        for date in dateSet {
            let dayData = data.filter({$0.key == date})
            var dayBalance = 0
            for d in dayData{
                dayBalance += d.value
            }
            result[date] = dayBalance / 10 * 100
        }
        
        return result
    }
    
    private func setIntervals(){
        for i in 0..<appleHealthValueArray.count{
            if appleHealthValueArray[i].day == appleHealthValueArray[i + 1].day &&
                Calendar.current.component(.hour, from: appleHealthValueArray[i].start) == Calendar.current.component(.hour, from: appleHealthValueArray[i + 1].start){
                appleHealthValueArray[i].nextTimeInterval = Int(DateInterval(start: appleHealthValueArray[i].end, end: appleHealthValueArray[i + 1].start).duration)
            }
        }
        
        for i in 1...appleHealthValueArray.count{
            if appleHealthValueArray[i].day == appleHealthValueArray[i + 1].day &&
                Calendar.current.component(.hour, from: appleHealthValueArray[i].start) == Calendar.current.component(.hour, from: appleHealthValueArray[i + 1].start){
                appleHealthValueArray[i].previousTimeInterval = Int(DateInterval(start: appleHealthValueArray[i - 1].end, end: appleHealthValueArray[i].start).duration)
            }
        }
    }
    
    private func mergeValues(_ value: [AppleHealthValue]) -> [AppleHealthValue]{
        var result: [AppleHealthValue] = []
        
        for i in 0...value.count{
            if value[i].previousTimeInterval == nil{
                result.append(value[i])
            } else{
                if value[i].previousTimeInterval! > 18{
                    result.append(value[i])
                }else{
                    if value[i].nextTimeInterval == nil{
                        result.append(value[i])
                    } else {
                        if let nti = value[i].nextTimeInterval{
                            if nti > 18{
                                result.append(value[i])
                            } else{
                                result.append(concatAppleHealthValues(first: value[i], second: value[i + 1]))
                            }
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    private func concatAppleHealthValues(first: AppleHealthValue, second: AppleHealthValue) -> AppleHealthValue{
        let day = first.day
        let start = first.start < second.start ? first.start : second.start
        let end = first.end > second.end ? first.end : second.end
        let value = first.value + second.value
        
        return AppleHealthValue(day: day, start: start, end: end, value: value)
    }
    
    private func splitAppleHealthValues(value: AppleHealthValue)-> [AppleHealthValue]{
        
        
        return []
    }
    
    
}
