//
//  FoldingTableViewCell.swift
//  Betterfly
//
//  Created by Dominick Hera on 12/25/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit
import FoldingCell

class FoldingTableViewCell: FoldingCell {
    
//    var postKey: String?
//    var postRef: DatabaseReference!
    
    @IBOutlet weak var closedFullDateLabel: UILabel!
    @IBOutlet weak var closeNumberLabel: UILabel!
    @IBOutlet weak var openNumberLabel: UILabel!
    @IBOutlet weak var openDateLabel: UILabel!
    @IBOutlet weak var openBodyTextView: UITextView!
    @IBOutlet weak var openImageView: UIImageView!
    @IBOutlet weak var openMonthLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var closedBodyTextView: UITextView!
    @IBOutlet weak var firstImageContainerView: UIView!
    
    
  
    
    @IBOutlet weak var barContainerView: UIView!
    
    
    
    
    
    @IBOutlet weak var secondContainerView: RotatedView!
    
    
    @IBOutlet weak var openDateBackgroundView: UIView!
    
    
    
    var number: Int = 0 {
        didSet {
//            closeNumberLabel.text = String(number)
//            openNumberLabel.text = String(number)
        }
    }

    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
        // Initialization code
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }

}

extension FoldingTableViewCell {
    
    //for action functions
    
    
}
