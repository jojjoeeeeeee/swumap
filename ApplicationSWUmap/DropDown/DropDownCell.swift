//
//  MyCell.swift
//  ApplicationSWUmap
//
//  Created by Thiti Watcharasottikul on 29/9/2563 BE.
//

import DropDown
import UIKit

class MyCell: DropDownCell {

    @IBOutlet var myImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myImageView.contentMode = .scaleAspectFit
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
