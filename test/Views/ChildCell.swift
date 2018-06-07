//
//  ChildCellTableViewCell.swift
//  test
//
//  Created by Bambang Oetomo, Jairo (NL - Amsterdam) on 07/06/2018.
//  Copyright © 2018 Bambang Oetomo, Jairo (NL - Amsterdam). All rights reserved.
//

import UIKit

class ChildCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
