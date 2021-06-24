//
//  MessageTableViewCell.swift
//  DatingDuell2
//
//  Created by tk on 16.06.21.
//

//CELL for Chat Message

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //set the values for top,left,bottom,right margins
//        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
//        contentView.frame = contentView.frame.inset(by: margins)
    }
    
}
