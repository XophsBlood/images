//
//  CustomFooterView.swift
//  Image
//
//  Created by Камиль Бакаев on 06.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
import UIKit

class CustomFooterView : UICollectionReusableView {
   
    @IBOutlet weak var refreshControlIndicator: UIActivityIndicatorView!
    
    var isAnimatingFinal:Bool = false
    var currentTransform:CGAffineTransform?
 
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareInitialAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setTransform(inTransform:CGAffineTransform, scaleFactor:CGFloat) {
        if isAnimatingFinal {
            return
        }
        
        self.currentTransform = inTransform
        self.refreshControlIndicator?.transform = CGAffineTransform.init(scaleX: scaleFactor, y: scaleFactor)
    }
    
    func prepareInitialAnimation() {
        self.isAnimatingFinal = false
        self.refreshControlIndicator?.stopAnimating()
        self.refreshControlIndicator?.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
    }
    
    func startAnimate() {
        self.isAnimatingFinal = true
        self.refreshControlIndicator?.startAnimating()
    }
    
    func stopAnimate() {
        self.isAnimatingFinal = false
        self.refreshControlIndicator?.stopAnimating()
    }
    
    func animateFinal() {
        if isAnimatingFinal {
            return
        }
        
        self.isAnimatingFinal = true
        
        UIView.animate(withDuration: 0.2) {
            self.refreshControlIndicator?.transform = CGAffineTransform.identity
        }
    }
}
