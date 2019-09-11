//
//  CardColCell.swift
//  CardFlipMatchGame
//
//  Created by Jayaprada Behera on 04/09/19.
//  Copyright © 2019 Jayaprada Behera. All rights reserved.
//

import Foundation
import UIKit
class CardColCell: UICollectionViewCell {
    
    
    @IBOutlet weak var frontImageView : UIImageView!
    @IBOutlet weak var backImageView : UIImageView!
    
    var card: Card?
    
    func setCard(_ card : Card){
        
        self.card = card
        
        
        if card.isMatched == true{
            //if cards has been matched ,make invisible
            self.frontImageView.alpha = 0
            self.backImageView.alpha = 0
            return
        }else{
            self.frontImageView.alpha = 1
            self.backImageView.alpha = 1
            
        }
        self.frontImageView.image  = UIImage(named:   self.card!.imageName)
        if self.card?.isFlipped == true{
            //front image on top
            UIView.transition(from: self.backImageView, to: self.frontImageView, duration: 0.1, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
            
        }else{
            //back image on top
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.1, options: [.transitionFlipFromRight,.showHideTransitionViews], completion: nil)
            
        }
//        self.backImageView.isHidden = true
//        self.frontImageView.isHidden = false
    }
    func flip(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            
            UIView.transition(from: self.backImageView, to: self.frontImageView, duration: 1.5, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
            
        }
    }
    func flipBack(){
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.5, options: [.transitionFlipFromRight,.showHideTransitionViews], completion: nil)
            
        }
    }
    func remove(){
        self.backImageView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
            
        }, completion: nil)
    }
}
