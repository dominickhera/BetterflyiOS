//
//  PhotosTableViewCell.swift
//  Betterfly
//
//  Created by Dominick Hera on 12/27/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit

protocol PhotoCellDelegate: class {
    func sharePressed(cell: PhotosTableViewCell)
    func editPhotoCell(_: Int)
    func deletePhotoCell(_: Int)
//        func editFoldingCell(_: Int)
//    func deleteFoldingCell(_: Int)
}


class PhotosTableViewCell: UITableViewCell {

    @IBOutlet weak var photoCellImageView: UIImageView!
    @IBOutlet weak var photoCellDateLabel: UILabel!
    
    @IBOutlet weak var photoCellShareIcon: UIButton!
    @IBOutlet weak var photoCellGradientView: UIView!
    @IBOutlet weak var photoCellTextBodyView: UITextView!
    var delegate: PhotoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    @IBAction func shareImageCell(_ sender: Any) {
//        print("booty")
//        delegate?.sharePressed(cell: self)
//    }
    
//    func deletePhotoCell(_ sender: Any) {
//        delegate?.deletePhotoCell(self.tag)
//    }
//
//     func editPhotoCell(_ sender: Any) {
//        delegate?.editPhotoCell(self.tag)
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension PhotosTableViewCell {
    @IBAction func shareImageCell(_ sender: Any) {
//        print("booty")
        delegate?.sharePressed(cell: self)
    }
    
    func deletePhotoCell(_ sender: Any) {
        print("delete, tag is \(self.tag)")
        delegate?.deletePhotoCell(self.tag)
    }
    
    func editPhotoCell(_ sender: Any) {
        print("edit, tag is \(self.tag)")
        delegate?.editPhotoCell(self.tag)
    }
}
