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
    @IBOutlet weak var dotImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func pop() {
        dotImage.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.dotImage.transform = CGAffineTransform(scaleX: 1, y: 1)
        },
            completion: nil)
    }

}
