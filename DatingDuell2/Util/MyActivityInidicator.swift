//
//  MyActivityInidikator.swift
//  DatingDuell2
//
//  Created by tk on 10.06.21.
//


import UIKit

//Activity Indicator to tell the user he should wait till its done.
class MyActivityInidicator {
    
    var view: UIView
    var overlayView: UIView
    var activityIndicatorV: UIActivityIndicatorView
    
    init (addToView: UIView){
        self.view = addToView
        self.overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        self.activityIndicatorV = UIActivityIndicatorView(style: .large)
        activityIndicatorV.frame = CGRect(x: 0, y: 0, width: activityIndicatorV.bounds.size.width, height: activityIndicatorV.bounds.size.height)
        
        
        activityIndicatorV.center = overlayView.center
        overlayView.addSubview(activityIndicatorV)
        overlayView.center = self.view.center
        self.view.addSubview(overlayView)
        overlayView.isHidden = true
    }
    
    func hideActivityIndicator(){
        self.overlayView.isHidden = true
        self.activityIndicatorV.stopAnimating()
    }
    
     
    func showActivityIndicator(){
        self.overlayView.isHidden = false
        self.activityIndicatorV.startAnimating()
    }
    
  
}
