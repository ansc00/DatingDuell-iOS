//
//  UserDuellView.swift
//  DatingDuell2
//
//  Created by tk on 11.06.21.
//

//View represents the Duell between two Users

import UIKit

class UserDuellView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var procentualLikesLabel: UILabel!
    @IBOutlet weak var sendMessageIV: UIImageView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed("UserDuellView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        
        addSubview(viewFromXib)
    }
    
   
}
