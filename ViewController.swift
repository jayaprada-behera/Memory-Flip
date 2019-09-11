//
//  ViewController.swift
//  CardFlipMatchGame
//
//  Created by Jayaprada Behera on 04/09/19.
//  Copyright © 2019 Jayaprada Behera. All rights reserved.
//

import UIKit
struct Card {
    
    var imageName = ""
    var isFlipped = false
    var isMatched = false
}
class ViewController: UIViewController {
    
    @IBOutlet weak var cardColView: UICollectionView!
    @IBOutlet weak var statusLbl: UILabel!

    var cardArray = [Card]()
    var matchedCardArray = [Card]()

     var firstFlippedCardIndex:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let nibNam = UINib.init(nibName: "CardColCell", bundle: nil)
        cardColView.register(nibNam, forCellWithReuseIdentifier: "CardColCell")
        cardArray = getCards()
        cardColView.reloadData()
    }
    
    @IBAction func shuffleBtnTapped(_ sender: Any) {
        statusLbl.text = ""

        cardArray.removeAll()
        DispatchQueue.main.async {
            self.cardColView.reloadData()
        }
        cardArray = getCards()

    }
    
    func getCards() -> [Card]{
        
        var generatedArray = [Card]()
        
        //randomly generate pair of number
        for _ in 1...8 {
            
            //get a random number
            let randomNumber = arc4random_uniform(13) + 1
            
            //print
//            print(randomNumber)
            
            //create the first Card Object
            var cardOne = Card()
            cardOne.imageName = "card\(randomNumber)"
            generatedArray.append(cardOne)
            
            //create the Second Card Object
            var cardTwo = Card()
            cardTwo.imageName = "card\(randomNumber)"
            generatedArray.append(cardTwo)
//            print(cardTwo.imageName,cardOne.imageName)
            
        }
//                print("generated array \(generatedArray)")
        return generatedArray.shuffled()
    }
    
    @objc func checkForMatches(_ secondFlippedCardIndex : IndexPath){
        
        //Get the cells for the two cards revealed
        let cellOne = self.cardColView.cellForItem(at: firstFlippedCardIndex!) as? CardColCell
        let cellTwo = self.cardColView.cellForItem(at: secondFlippedCardIndex) as? CardColCell
        //Get the cards for the two cards revealed
        var cardOne = cardArray[firstFlippedCardIndex!.item]
        var cardTwo = cardArray[secondFlippedCardIndex.item]
        
        //compare two cards
//        print(firstFlippedCardIndex?.row as Any,secondFlippedCardIndex.row)
        print(cardOne.imageName)
        print(cardTwo.imageName)
        
        if cardOne.imageName == cardTwo.imageName {
            //matched
            print("matched")
            
            //set the satus of the two cards
            //remove the two cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            
            matchedCardArray.append(cardOne)
            matchedCardArray.append(cardTwo)
            
            //check if all cards matching done
            
            if self.isAllCardsMatchingDone(){
                print("Game Over")
                statusLbl.text = "Game Over"
            }else{
//                print("Not Over")

            }
            DispatchQueue.main.async {
                
                cellOne?.remove()
                cellTwo?.remove()
            }
            

        }else{
            //set the satus of the two cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            print("Not matched")
            
            //flip both cards
            DispatchQueue.main.async {

            cellOne?.flipBack()
            cellTwo?.flipBack()
            }
            
        }
        
        self.cardArray[secondFlippedCardIndex.item] = cardTwo
        self.cardArray[firstFlippedCardIndex!.item] = cardOne

        DispatchQueue.main.async {
            self.cardColView.reloadItems(at: [self.firstFlippedCardIndex!])
            self.firstFlippedCardIndex = nil
        }
        
    }
    
    func isAllCardsMatchingDone() -> Bool{
        
        let cardAr = cardArray.map({ $0.imageName })
        let matchedCardAr = matchedCardArray.map({ $0.imageName })
        
        let cardSet = Set(cardAr)
        let matchedCardSet = Set(matchedCardAr)
//        let allElemsContained = matchedCardSet.isSubset(of: cardSet)
//        print(allElemsContained)
        
        if cardSet == matchedCardSet {
            return true
        }
        
        return false
        
    }
    
}
extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell:CardColCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardColCell", for: indexPath)  as! CardColCell
        let card = cardArray[indexPath.item]
        cell.setCard(card)
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)  as! CardColCell
        
        var card = cardArray[indexPath.item]
        
        if card.isFlipped == false && card.isMatched == false{
            //Flip the card
            cell.flip()
            //Change status of the card
            card.isFlipped = true
            
            //determine if its the first card or second card
            
            if firstFlippedCardIndex == nil{
                //this is the first card being flipped
                firstFlippedCardIndex = indexPath
                
            }else{
                //this is the second card being flipped
                //Perform matching logic
                
                self.perform(#selector(checkForMatches(_:)), with: indexPath, afterDelay: 2)
//                self.checkForMatches(indexPath)
            }
        }else{
            cell.flipBack()
            card.isFlipped = false
        }
        
        
    }
}
