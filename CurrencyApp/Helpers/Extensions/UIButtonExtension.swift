//
//  UIView Extensions.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 18/11/2022.
//

import Foundation
import UIKit


@IBDesignable
class DesignableButton: UIButton {
    
    @IBInspectable var leftHandImage: UIImage? {
        didSet {
            leftHandImage = leftHandImage?.withRenderingMode(.alwaysOriginal)
            setupValues()
        }
    }
    
    @IBInspectable var rightHandImage: UIImage? {
        didSet {
            rightHandImage = rightHandImage?.withRenderingMode(.alwaysTemplate)
            setupValues()
        }
    }
    
    @IBInspectable var leftImageSize: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            setupValues()
        }
    }
    
    @IBInspectable var rightImageSize: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            setupValues()
        }
    }
    
    @IBInspectable var leftImagePadding: CGFloat = 20.0 {
        didSet {
            setupValues()
        }
    }
    
    @IBInspectable var RightImagePadding: CGFloat = 30.0 {
        didSet {
            setupValues()
        }
    }
    
    @IBInspectable var LeftImageRtl: Bool = false {
        didSet {
            setupValues()
        }
    }
    
    @IBInspectable var RightImageRtl: Bool = false {
        didSet {
            setupValues()
        }
    }
    
    @IBInspectable var LImageTPadding: CGFloat = 0.0 {
        didSet {
            setupValues()
        }
    }
    
    @IBInspectable var RImageTPadding: CGFloat = 0.0 {
        didSet {
            setupValues()
        }
    }
    
    func setupValues() {
        setupImages(leftImageSize.width,leftImageSize.height,rightImageSize.width,rightImageSize.height,leftImagePadding,RightImagePadding,LeftImageRtl,RightImageRtl,LImageTPadding,RImageTPadding)
    }
    
    func setupImages(_ LWidth: CGFloat = 16.7,_ LHieght: CGFloat = 16.7,_ RWidth: CGFloat = 13.3,_ RHieght: CGFloat = 13.3,_ leftPadding: CGFloat = 20.0,_ rightPadding: CGFloat = 30.0,_ leftImageRtl: Bool = false,_ rightImageRtl: Bool = false,_ lImageTPadding: CGFloat = 0.0,_ rImageTPadding: CGFloat = 0.0)  {
        if let leftImage = leftHandImage {
            let leftImageView = UIImageView(image: leftImage)
            var xPos: CGFloat = 0
          
            let yPos = (self.frame.height - (self.frame.height / 2) - (LHieght / 2)) - lImageTPadding
            leftImageView.frame = CGRect(x: xPos, y: yPos, width: LWidth, height: LHieght)
            self.addSubview(leftImageView)
        }
        
        if let rightImage = rightHandImage {
            let rightImageView = UIImageView(image: rightImage)
            rightImageView.tintColor = self.tintColor
            let height = self.frame.height * 0.2
            var xPos: CGFloat = 0
      
            let yPos = (self.frame.height - height) / 2 - rImageTPadding
            rightImageView.frame = CGRect(x: xPos, y: yPos, width: RWidth, height: RHieght)
            self.addSubview(rightImageView)
        }
    }
}
