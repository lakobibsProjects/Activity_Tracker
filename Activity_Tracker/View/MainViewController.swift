//
//  MainViewController.swift
//  Activity_Tracker
//
//  Created by user166683 on 12/11/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import UIKit
//import Snapkit

class MainViewController: UIViewController {
    weak var coordinator: Coordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    var label: UILabel!
    
    //MARK: - Support Functions
    private func setup(){
        initViews()
        setupViews()
        setupConstraints()
    }
    
    private func initViews(){
        label = UILabel()
        let reader = CSVReader()
        reader.getHealthUnitArray()
    }
    
    //MARK: - Event Handlers
}

//MARK: - Layout
extension MainViewController{
    private func setupViews(){
        self.view.addSubview(label)
    }
    
    private func setupConstraints(){
        
    }
}
