//
//  RoundedButton.swift
//  DatingDuell
//
//  Created by tk on 20.05.21.
//

//Class for Buttons with rounded corner (all Buttons have same style)

import UIKit

class RoundedButton: UIButton {

    
   
    override init(frame: CGRect){
        super.init(frame: frame)
        
       
    }

    required init?(coder cod: NSCoder) {
        super.init(coder: cod)
    }
    
   

    override func layoutSubviews() {
        super.layoutSubviews()
    
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        clipsToBounds = true
        
//        layer.backgroundColor = Colors.colorWithHexString(hexString: Colors.quaternaryColorAsHexCode).cgColor
    }
    
   
    
}
