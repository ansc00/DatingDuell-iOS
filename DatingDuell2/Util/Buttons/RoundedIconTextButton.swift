//
//  RoundedIconTextButton.swift
//  DatingDuell
//
//  Created by tk on 22.05.21.
//

// class for Buttons with a icon and text

import UIKit


struct IconTextButtonViewModel {
    let labelText: String
    let image: UIImage?
}

//@IBDesignable
class RoundedIconTextButton: UIButton {

    private var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    //var borderWidth: CGFloat = 2.0
    private var iconImageView: UIImageView = {
       let imageView = UIImageView()
        //let image = UIImage(named: "gmail")
        //imageView.image = #imageLiteral(resourceName: "fb") //#imageLiteral(resourceName: "feedback")
        //imageView.image = image
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
      //  imageView.backgroundColor = .blue
        return imageView
    }()

//    @IBInspectable var iconImage: UIImage? {
//        didSet {
//            myImageView.image = iconImage
//        }
//    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(label)
        addSubview(iconImageView)
       
    }

    required init?(coder cod: NSCoder) {
        super.init(coder: cod)
    }
    
    func configure(with viewModel: IconTextButtonViewModel){
        label.text = viewModel.labelText
        iconImageView.image = viewModel.image
        
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        clipsToBounds = true
        
        layer.backgroundColor = UIColor.white.cgColor
        
        label.sizeToFit()
        let iconSize: CGFloat = 18
//        let iconX: CGFloat = (frame.size.width - label.frame.size.width - iconSize - 5) / 2
//        iconImageView.frame = CGRect(x: iconX, y: (frame.size.height - iconSize) / 2, width: iconSize, height: iconSize)
//        label.frame = CGRect(x: iconX + iconSize + 5, y: 0, width: label.frame.size.width, height: frame.size.height)
//
        let iconX: CGFloat =  10
        iconImageView.frame = CGRect(x: iconX, y: (frame.size.height - iconSize) / 2, width: iconSize, height: iconSize)
        label.frame = CGRect(x:  (frame.size.width / 2) - (label.frame.size.width / 2), y: 0, width: label.frame.size.width, height: frame.size.height)
       
        
    }
    
   


}
