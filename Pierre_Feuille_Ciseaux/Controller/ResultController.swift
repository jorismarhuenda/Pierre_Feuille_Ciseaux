//
//  ResultController.swift
//  Pierre_Feuille_Ciseaux
//
//  Created by marhuenda joris on 25/11/2021.
//

import SwiftUI

class ResultController: UIViewController {
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    var gameEngine: GameEngine?
    var delegate: GameDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let receivedGE = gameEngine {
            resultLabel.text = receivedGE.resultString
            
            if receivedGE.resultString == "YOU WON" && receivedGE.gameType == .HumanVsBot {
                bannerImageView.image = UIImage(named: "wonboy")
            } else {
                bannerImageView.image = UIImage(named: "robot")
            }
        }
    }
    
    @IBAction func playAgainButtonTouched(_ sender: Any) {
        if let delegate = self.delegate, let gameEngine = self.gameEngine {
            self.dismiss(animated: true, completion: nil)
            delegate.didPlaySameGame(result: gameEngine)
        }
    }
    
    @IBAction func changeModeButtonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
