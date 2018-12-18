//
//  CustomTableViewCell.swift
//  TrendPlay 
//
//  Created by Chelsea Smith on 8/11/17.
//  Copyright © 2017 Trending Productions LLC. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = darkGreyColor
        self.selectionStyle = .none
        self.accessoryType = isSelected ? .checkmark : .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
