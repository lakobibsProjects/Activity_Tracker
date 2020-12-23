
//
//  MainViewModel.swift
//  Activity_Tracker
//
//  Created by user166683 on 12/15/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import Foundation

///Protocol that describe data for MainViewController
protocol MainVMProtocol: class {
    var appleHealthConvetor: AppleHealthConvertorProtocol{ get }
    var allDaysBalance: [(date:Date, points: Int, balance: Int)] { get }
    
    func updateData()
    
    func attach(_ observer: MainViewController)
    func detach(_ observer: MainViewController)
    func notify()
    
    func update(subject: AppleHealthConvertorProtocol)
}

///Class that contains data for MainViewController
///Comment: subscribe ViewController in Coordinator with `attach` method
class MainViewModel: MainVMProtocol, AppleHealthConvertorObserver{
    var appleHealthConvetor: AppleHealthConvertorProtocol = AppleHealthConvertor.shared
    private var dateSet: Set<Date>?
    var allDaysBalance: [(date:Date, points: Int, balance: Int)] = []
    private lazy var observers = [MainViewController]()
    
    init(){
        appleHealthConvetor.attach(self)
    }
    
    func updateData(){
        dateSet = appleHealthConvetor.dateSet
        if appleHealthConvetor.getAllDaysBalance().count > 0{
            allDaysBalance = appleHealthConvetor.getAllDaysBalance().sorted(by: {$1.date > $0.date})
            notify()
        }
    }
    
    //observer
    ///Reaction to change AppleHealthConvertorObservable
    func update(subject: AppleHealthConvertorProtocol) {
        updateData()
    }
    
    //MARK: - Observable
    ///Add subscriber
    ///
    /// - Parameter _: subscriber to add
    func attach(_ observer: MainViewController) {
        observers.append(observer)
    }
    
    ///Remove subscriber
    ///
    /// - Parameter subscriber: subscriber to remove
    func detach(_ observer: MainViewController) {
        if let idx = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: idx)
        }
    }
    
    ///Notify all observers about changes
    func notify() {
        print("Subject: Notifying observers...\n")
        observers.forEach({ $0.update(self)})
    }
}
