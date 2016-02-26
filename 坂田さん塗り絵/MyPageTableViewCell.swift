//
//  MyPageTableViewCell.swift
//  坂田さん塗り絵
//
//  Created by HARADA REO on 2016/02/27.
//  Copyright © 2016年 reo harada. All rights reserved.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var paintImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
