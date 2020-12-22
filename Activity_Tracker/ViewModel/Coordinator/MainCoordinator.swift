//
//  MainCoordinator.swift
//  Activity_Tracker
//
//  Created by user166683 on 12/11/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Methods

    func start() {
        let vc = MainViewController.init()
        vc.coordinator = self
        vc.vm = MainViewModel()
        vc.vm?.attach(vc)
        navigationController.pushViewController(vc, animated: true)
    }

   
}
