//
//  textBodyTableViewCell.swift
//  Betterfly
//
//  Created by Dominick Hera on 10/4/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit

class textBodyTableViewCell: UITableViewCell {

var PostInfoViewController: PostInfoViewController?
    
    
    @IBOutlet weak var bodyTextField: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
