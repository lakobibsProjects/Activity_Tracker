//
//  CoordinatorProtocol.swift
//  Activity_Tracker
//
//  Created by user166683 on 12/11/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class {
    var navigationController: UINavigationController { get }
    func start()
}
