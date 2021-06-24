//
//  RoundedCornerViewElement.swift
//  DatingDuell
//
//  Created by tk on 20.05.21.
//


// For every view that need rounded Corners
import UIKit

class RoundedCornerViewElement: UIView {

    
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    

}
