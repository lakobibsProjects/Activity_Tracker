//
//  HourTableViewCell.swift
//  Activity_Tracker
//
//  Created by user166683 on 12/15/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import UIKit

class HourTableViewCell: UITableViewCell {
    
    var hourPointsLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCell(with data: (Date, Int)){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        hourPointsLabel.text = "at \(formatter.string(from: data.0)) you take \(data.1) points"
    }
    
    private func setup(){
        initViews()
        setupViews()
        setupConstraints()
    }
    
    private func initViews(){
        
    }
    
    private func setupViews(){
        self.addSubview(hourPointsLabel)
    }
    
    private func setupConstraints(){
        hourPointsLabel.snp.makeConstraints({
            $0.leading.top.bottom.equalToSuperview().inset(8)
            $0.trailing.lessThanOrEqualToSuperview().inset(8)
        })
    }
}
