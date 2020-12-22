
//
//  MainViewModel.swift
//  Activity_Tracker
//
//  Created by user166683 on 12/15/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import Foundation

protocol MainVMProtocol: class {
    var appleHealthConvetor: AppleHealthConvertorProtocol{ get }
    var allDaysBalance: [(date:Date, points: Int, balance: Int)] { get }
    
    func attach(_ observer: MainViewController)
    func detach(_ observer: MainViewController)
    func updateData()
}

class MainViewModel: MainVMProtocol, AppleHealthConvertorObserver{
    var appleHealthConvetor: AppleHealthConvertorProtocol = AppleHealthConvertor.shared
    private var dateSet: Set<Date>?
    var allDaysBalance: [(date:Date, points: Int, balance: Int)] = []
    private lazy var observers = [MainViewController]()
    
    private let writer = CSVWriter()
    static var i = 0
    init(){
        print(MainViewModel.i)
        MainViewModel.i = MainViewModel.i + 1
        appleHealthConvetor.attach(self)
    }
    func updateData(){
        print("update data")
        dateSet = appleHealthConvetor.dateSet
        print("data: \n \(appleHealthConvetor.getAllDaysBalance())")
        if appleHealthConvetor.getAllDaysBalance().count > 0{
            allDaysBalance = appleHealthConvetor.getAllDaysBalance().sorted(by: {$1.date > $0.date})
            notify()
        }

    }
    
    func update(subject: AppleHealthConvertorProtocol) {
        updateData()
        writer.writeCSV(from: appleHealthConvetor.convertToCSV())
    }
    
    //MARK: - Observable
    func attach(_ observer: MainViewController) {
        observers.append(observer)
    }

    func detach(_ observer: MainViewController) {
        if let idx = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: idx)
        }
    }

    
    func notify() {
        print("Subject: Notifying observers...\n")
        observers.forEach({ $0.update(self)})
    }
}
