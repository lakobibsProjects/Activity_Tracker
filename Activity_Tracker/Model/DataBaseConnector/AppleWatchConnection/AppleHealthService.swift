//
//  AppleHealthService.swift
//  HealthTrackerCalculator
//
//  Created by user166683 on 12/12/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import Foundation

///Protocol that describe working with AppleHelath
///Comment: implement AppleHealthServiceObserver when add instance of clas that eimplement this protocol
protocol AppleHealthServiceProtocol: AppleHealthServiceObservable{
    var reader: AppleHealthProvider { get }
    var writer: CSVWriterProtocol { get }
    
    func writeData(from array: [Dictionary<String, AnyObject>])
    func getData() -> [AppleHealthValue]
}

protocol AppleHealthServiceObservable{
    func attach(_ observer: AppleHealthServiceObserver)
    
    func detach(subscriber filter: (AppleHealthServiceObserver) -> (Bool))
}

protocol AppleHealthServiceObserver{
    func update(subject: AppleHealthServiceProtocol)
}



///Class for reading Apple Health data and writing results
class AppleHealthService: AppleHealthServiceProtocol{
    var writer: CSVWriterProtocol = CSVWriter()
    var reader: AppleHealthProvider = CSVReader()
    private var appleHealthValueArray: [AppleHealthValue] = []
    private var thread = DispatchQueue.global(qos: .background)
    private lazy var observers = [AppleHealthServiceObserver]()
    
    //begin singleton
    static var shared: AppleHealthService {
        let instance = AppleHealthService()
        instance.updateInfo()
        
        return instance
    }
    
    private init(){
    }
    //end singleton
    
    //MARK: - AppleHealthServiceProtocol Functions
    /// Method, that returns balance points for complete period of observation
    ///
    /// - Returns: Array of AppleHealthValue
    func getData() -> [AppleHealthValue] {
        return appleHealthValueArray
    }
    
    /// Write data to .csv file
    func writeData(from array: [Dictionary<String, AnyObject>]) {
        writer.writeCSV(from: array)
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
            DispatchQueue.main.async {
                self.notify()
            }
            
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


//MARK: - Observable
extension AppleHealthService: AppleHealthServiceObservable{
    ///Add subscriber
    ///
    /// - Parameter _: subscriber to add
    func attach(_ observer: AppleHealthServiceObserver) {
        observers.append(observer)
    }
    
    ///Remove subscriber
    ///
    /// - Parameter subscriber: subscriber to remove
    func detach(subscriber filter: (AppleHealthServiceObserver) -> (Bool)) {
        guard let index = observers.firstIndex(where: filter) else { return }
        observers.remove(at: index)
    }
    
    ///Notify all observers about changes
    func notify() {
        observers.forEach({ $0.update(subject: self)})
    }
}
