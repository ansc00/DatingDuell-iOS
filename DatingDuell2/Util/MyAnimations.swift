//
//  MyAnimations.swift
//  DatingDuell2
//
//  Created by tk on 11.06.21.
//

//Class for some awesome animations

import UIKit

class MyAnimations {
    
    static func labelsLeftAndUpAnimation(titleView: UIView, bodyView: UIView?){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            titleView.transform = CGAffineTransform(translationX: -30, y: 0) //left
        } completion: { _ in
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                
                titleView.alpha = 0 //hide
                titleView.transform = CGAffineTransform(translationX: -30, y: -200) //up
            } completion: { _ in
                
            }

        }
        
        //second view //delay added
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            guard let bodyV = bodyView else { return }
            bodyV.transform = CGAffineTransform(translationX: -30, y: 0) //left
        } completion: { _ in
            
            
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                guard let bodyV = bodyView else { return }
                bodyV.alpha = 0 //hide
                bodyV.transform = CGAffineTransform(translationX: -30, y: -200) //up //TAKE this new position
//                bodyView.transform.translatedBy(x: 0, y: -200) //move (from old pos) to new position
            } completion: { _ in
                
            }

        }

    }
    
    
    static func fadeOut(_ view: UIView, _ duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            view.alpha = 0.0
        })
      }
}
