
//
//  MainViewModel.swift
//  Activity_Tracker
//
//  Created by user166683 on 12/15/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol MainVMProtocol: class {
    var appleHealthConvetor: AppleHealthConvertorProtocol{ get }
    var allDaysBalance: PublishSubject<[(date:Date, points: Int, balance: Int)]> { get }
    
    func updateData()
}

class MainViewModel: MainVMProtocol{
    var appleHealthConvetor: AppleHealthConvertorProtocol = AppleHealthConvertor()
    private var dateSet: Set<Date>?
    var allDaysBalance = PublishSubject<[(date:Date, points: Int, balance: Int)]>()
    
    private let writer = CSVWriter()
    
    func updateData(){
        dateSet = appleHealthConvetor.dateSet
        let temp = appleHealthConvetor.getAllDaysBalance()
        
        allDaysBalance.onNext(temp)
        allDaysBalance.onCompleted()

        writer.writeCSV(from: appleHealthConvetor.convertToCSV())
    }
}
