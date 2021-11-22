//
//  Player.swift
//  Pierre_Feuille_Ciseaux
//
//  Created by marhuenda joris on 22/11/2021.
//

import Foundation

enum Players {
    case playerOne
    case playerTwo
}

class Player {
    //score of the player is private so can't be accessed from outside
    private var currentScore: Int
    //player score can be updated via this variable after going through the validations
    var playerScore: Int {
        set(newValue) {
            if newValue >= 0 && newValue > currentScore  {
                currentScore = newValue
            }
        }
        get {
            return currentScore
        }
    }
    
    let playerType: Players
    
    init(playerScore: Int = 0, playerType: Players) {
        self.currentScore = playerScore
        self.playerType = playerType
        self.playerScore = playerScore
    }
}
