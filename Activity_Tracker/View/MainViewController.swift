//
//  MainViewController.swift
//  Activity_Tracker
//
//  Created by user166683 on 12/11/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    weak var coordinator: Coordinator?
    var vm: MainVMProtocol?
    
    private let bag = DisposeBag()
    
 
    
    var dayBalancePointTableView: UITableView!
    //Not work. Add functional later
    //var hourBalancePointTableView: UITableView!
    //var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        vm?.updateData()
    }

    
    //MARK: - Support Functions
    private func setup(){
        initViews()
        setupViews()
        setupConstraints()
    }
    
    private func initViews(){
        self.view.backgroundColor = .systemGreen
        
        dayBalancePointTableView = UITableView()
        dayBalancePointTableView.register(DayTableViewCell.self, forCellReuseIdentifier: "DayCell")
        dayBalancePointTableView.rx.setDelegate(self).disposed(by: bag)
        vm?.allDaysBalance.bind(to: dayBalancePointTableView.rx.items(cellIdentifier: "DayCell", cellType: DayTableViewCell.self)) { (row,item,cell) in
            cell.configureCell(with: (item.date, item.points))
        }.disposed(by: bag)
        
        //Not work. Add functional later
        /*hourBalancePointTableView = UITableView()
        hourBalancePointTableView.register(HourTableViewCell.self, forCellReuseIdentifier: "HourCell")
        hourBalancePointTableView.delegate = self
        hourBalancePointTableView.dataSource = self
        hourBalancePointTableView.isHidden = true
        
        backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.isHidden = true
        backButton.addTarget(self, action: #selector(changeTable), for: .touchUpInside)*/
    }
    
    
    
    //MARK: - Event Handlers
    //Not work. Add functional later
    /*@objc private func changeTable(){
        dayBalancePointTableView.isHidden = !dayBalancePointTableView.isHidden
        hourBalancePointTableView.isHidden = !hourBalancePointTableView.isHidden
        backButton.isHidden = !hourBalancePointTableView.isHidden
    }*/
}

//MARK: - TableView
extension MainViewController: UITableViewDelegate{
    private func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0{
            if tableView == dayBalancePointTableView{
                return "Balance per day"
            } else{
                return "Balance points in hour"
            }
        }
        return ""
    }
}

//MARK: - Layout
extension MainViewController{
    private func setupViews(){
        self.view.addSubview(dayBalancePointTableView)
        //Not work. Add functional later
        /*self.view.addSubview(hourBalancePointTableView)
        self.view.addSubview(backButton)*/
    }
    
    private func setupConstraints(){
        dayBalancePointTableView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(64)
            $0.top.equalToSuperview().inset(128)
        })
        
        //Not work. Add functional later
        /*hourBalancePointTableView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(64)
            $0.top.equalToSuperview().inset(128)
        })
        
        backButton.snp.makeConstraints({
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalTo(hourBalancePointTableView.snp.top).offset(8)
            $0.height.equalTo(64)
            $0.width.equalTo(128)
        })*/
    }
}
