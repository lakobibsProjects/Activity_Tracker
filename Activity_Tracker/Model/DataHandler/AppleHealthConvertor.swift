
//
//  AppleHealthConvertor.swift
//  HealthTrackerCalculator
//
//  Created by user166683 on 12/15/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import Foundation

///Protocol that describe convertion of Apple Helth data to health points
protocol AppleHealthConvertorProtocol: class, AppleHealthConvertorObservable {
    var appleHealthService: AppleHealthServiceProtocol { get }
    var dateSet: Set<Date> { get }
    
    func getAllDaysBalance() -> [(date:Date, points: Int, balance: Int)]
    func getBalancePoints(byDate: Date) -> [(date:Date, points: Int)]
    func getAllBalancePoints() -> [(date:Date, points: Int)]
    func convertToCSV()-> [Dictionary<String, AnyObject>]
}

protocol AppleHealthConvertorObservable{
    func attach(_ observer: AppleHealthConvertorObserver)
    
    func detach(subscriber filter: (AppleHealthConvertorObserver) -> (Bool))
}

protocol AppleHealthConvertorObserver{
    func update(subject: AppleHealthConvertorProtocol)
}


///Class return data about inday activity
class AppleHealthConvertor: AppleHealthConvertorProtocol{
    var appleHealthService: AppleHealthServiceProtocol = AppleHealthService.shared
    
    private var data: [AppleHealthValue] = []
    private lazy var observers = [AppleHealthConvertorObserver]()
    private var allDayBalance: [(date:Date, points: Int, balance: Int)] = []
    var dateSet: Set<Date> { return Set(data.map({ return $0.day }))}
    
    //begin singleton
    static var shared: AppleHealthConvertor {
        let instance = AppleHealthConvertor()
        instance.data = instance.appleHealthService.getData()
        instance.appleHealthService.attach(instance)
        //instance.updateAllDayBalance()
        
        return instance
    }
    
    private init() {
    }
    //end singleton
    //MARK: - AppleHealthConvertorProtocol Functions
    /// Method, that returns balance in days
    ///
    /// - Returns: Array of Tupples
    ///                       - day of observation
    ///                       - balance in percents
    func getAllDaysBalance() -> [(date:Date, points: Int, balance: Int)] {
        return allDayBalance
    }
    
    
    /// Convert balance to CSV-writable
    ///
    /// - Returns: Dictoinary for writing to .csv
    func convertToCSV()-> [Dictionary<String, AnyObject>]{
        var result = [Dictionary<String, AnyObject>]()
        for balance in getAllDaysBalance(){
            var dict = Dictionary<String, AnyObject>()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            dict["day"] = formatter.string(from: balance.date) as AnyObject
            dict["balance_points"] = balance.points as AnyObject
            dict["balance_day"] = balance.balance as AnyObject
            result.append(dict)
        }
        
        return result
    }
    
    /// Method, that returns balance points for date
    ///
    /// - Parameter byDate: date on which return result of observation
    /// - Returns: Array of Tupples
    ///                       - date of observation
    ///                       - balance points
    func getBalancePoints(byDate: Date) -> [(date:Date, points: Int)] {
        return getAllBalancePoints().filter({$0.date == byDate})
    }
    
    /// Method, that returns balance points for complete period of observation
    ///
    /// - Returns: Array of Tupples
    ///                       - date of observation
    ///                       - balance point
    func getAllBalancePoints() -> [(date:Date, points: Int)]{
        var result = [(date:Date, points: Int)]()
        for value in dateSet{
            let dayData = mergeValues(data.filter({$0.day == value}))
            for i in 0...23{
                let hourData = dayData.filter({Calendar.current.component(.hour, from: $0.start) == i})
                for item in 0..<hourData.count{
                    let components = Calendar.current.dateComponents([.second, .minute], from: hourData[item].start)
                    let comp = DateComponents(minute: -components.minute!, second: -components.second!)
                    let date = Calendar.current.date(byAdding: comp, to: hourData[item].start)!
                    
                    if hourData[item].length > 180{
                        if result.contains(where: {$0.date == date}){
                            result[result.lastIndex(where: {$0.date == date})!] = (date, 2)
                        } else{
                            result.append((date, 1))
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    //MARK: - Support Functions
    ///Update allDayBalance when change input data
    private func updateAllDayBalance(){
        var result = [(date:Date, points: Int, balance: Int)]()
        let data = getAllBalancePoints()
        
        for date in dateSet {
            let dayData = data.filter({$0.date == date})
            var dayBalance = 0
            for d in dayData{
                dayBalance += d.points
            }
            result.append((date, dayBalance, dayBalance * 10))
        }
        allDayBalance = result
        notify()
    }
    
    /// Merge periods with short interval
    ///
    /// - Parameter value: parsed result of reading Apple Health file
    /// - Returns: Updated array of AppleHealthValue
    private func mergeValues(_ value: [AppleHealthValue]) -> [AppleHealthValue]{
        var result: [AppleHealthValue] = []
        
        for i in 0..<value.count{
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
    
    /// Unite two AppleHealthValue
    /// ///
    /// - Parameter -first: earled AppleHealthValue
    ///             - second: lated AppleHealthValue
    /// - Returns: United AppleHealthValue
    private func concatAppleHealthValues(first: AppleHealthValue, second: AppleHealthValue) -> AppleHealthValue{
        let day = first.day
        let start = first.start < second.start ? first.start : second.start
        let end = first.end > second.end ? first.end : second.end
        let value = first.value + second.value
        
        return AppleHealthValue(day: day, start: start, end: end, value: value)
    }
}

//MARK: - Observable
extension AppleHealthConvertor: AppleHealthConvertorObservable{
    ///Add subscriber
    ///
    /// - Parameter _: subscriber to add
    func attach(_ observer: AppleHealthConvertorObserver) {
        observers.append(observer)
    }
    
    ///Remove subscriber
    ///
    /// - Parameter subscriber: subscriber to remove
    func detach(subscriber filter: (AppleHealthConvertorObserver) -> (Bool)) {
        guard let index = observers.firstIndex(where: filter) else { return }
        observers.remove(at: index)
    }
    
    ///Notify all observers about changes
    func notify() {
        observers.forEach({ $0.update(subject: self)})
    }
}

//MARK: - Observer
extension AppleHealthConvertor: AppleHealthServiceObserver{
    ///Reaction to change AppleHealthServiceObservable
    func update(subject: AppleHealthServiceProtocol){
        data = appleHealthService.getData()
        updateAllDayBalance()
        appleHealthService.writeData(from: convertToCSV())
    }
}
