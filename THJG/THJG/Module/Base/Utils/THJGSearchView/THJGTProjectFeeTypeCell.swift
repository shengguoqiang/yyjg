//
//  THJGTProjectFeeTypeCell.swift
//  THJG
//
//  Created by 大强神 on 2019/8/1.
//  Copyright © 2019 中南金融. All rights reserved.
//

import UIKit

class THJGTProjectFeeTypeCell: UITableViewCell {

    @IBOutlet weak var feeNameLabel: UILabel!
    
    var bean: SmallTypeBean! {
        didSet {
            feeNameLabel.text = bean.smallTypeName
        }
    }
    
}
