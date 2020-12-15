//
//  CSVWriter.swift
//  Activity_Tracker
//
//  Created by user166683 on 12/11/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import Foundation

protocol CSVWriterProtocol{
    func createCSV(from array:[Dictionary<String, AnyObject>])
}
