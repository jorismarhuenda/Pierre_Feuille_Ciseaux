//
//  ExtensionGameController.swift
//  Pierre_Feuille_Ciseaux
//
//  Created by marhuenda joris on 22/11/2021.
//

import SwiftUI

extension GameController {
    //MARK:- Game logics
    func buttonTouchedActions(selection: GameSelection) {
        disableButtons()
        if let gameEngine = self.gameEngine, gameEngine.gameType == .HumanVsBot   {
            timer?.invalidate()
        }
        timerView.isHidden = true
        if selection == .Rock {
            playerTwoSelectionImageView.image = UIImage(named: "rock")
        } else if selection == .Paper {
            playerTwoSelectionImageView.image = UIImage(named: "paper")
        } else if selection == .Scissors {
            playerTwoSelectionImageView.image = UIImage(named: "scissors")
        }
        
        checkTheWinner(selection: selection)
    }
    
    func checkTheWinner(selection: GameSelection) {
        guard let gameEngine = self.gameEngine else {
            return
        }
        let botSelection = gameEngine.randomSelection()
        
        if botSelection == .Rock {
            playerOneSelectionImageView.image = UIImage(named: "rock")
        } else if botSelection == .Paper {
            playerOneSelectionImageView.image = UIImage(named: "paper")
        } else if botSelection == .Scissors {
            playerOneSelectionImageView.image = UIImage(named: "scissors")
        }
        
        let winnerStateForPlayerTwo = gameEngine.checkWinner(selectionOne: botSelection, selectionTwo: selection)
        if winnerStateForPlayerTwo == .Draw {
            print("Egalité")
            updatesLabel.text = "Egalité"
        } else if winnerStateForPlayerTwo == .Lose {
            print("Perdu")
            if gameEngine.gameType == .HumanVsBot {
                updatesLabel.text = "BOT gagne le tour!"
            } else {
                updatesLabel.text = "BOT 1 gagne le tour!"
            }
            
            gameEngine.playerOneScored()
        } else if winnerStateForPlayerTwo == .Won {
            print("Gagné")
            if gameEngine.gameType == .HumanVsBot {
                updatesLabel.text = "Tu gagne le tour!"
            } else {
                updatesLabel.text = "BOT 2 gagne le tour!"
            }
            gameEngine.playerTwoScored()
        }
        
        updateGameScore()
        if let gameEngine = self.gameEngine, gameEngine.gameType == .HumanVsBot   {
            startTimer()
        }
        
    }
    
    func updateGameScore() {
        if let gameEngine = gameEngine {
            UIView.animate(withDuration: 0.5) {
                if gameEngine.gameType == .HumanVsBot {
                    self.playerOneScoreLabel.text = "BOT: \(gameEngine.playerOne.playerScore)"
                    self.playerTwoScoreLabel.text = "Toi: \(gameEngine.playerTwo.playerScore)"
                } else if  gameEngine.gameType == .BotVsBot {
                    self.playerOneScoreLabel.text = "BOT 1: \(gameEngine.playerOne.playerScore)"
                    self.playerTwoScoreLabel.text = "BOT 2: \(gameEngine.playerTwo.playerScore)"
                }
            }
        }
    }
    
    func checkGameStatus() {
        guard let gameEngine = self.gameEngine else {
            return
        }
        var isGameOver: Bool = false
        var returnString: String = ""
        let numberOfRounds = gameEngine.numberOfRounds - 1
        
        if gameEngine.playerOne.playerScore > numberOfRounds && gameEngine.gameType == .HumanVsBot {
            isGameOver = true
            returnString = "BOT Gagne"
        } else if gameEngine.playerTwo.playerScore > numberOfRounds && gameEngine.gameType == .HumanVsBot{
            isGameOver = true
            returnString = "Tu gagne"
        } else if gameEngine.playerOne.playerScore > numberOfRounds && gameEngine.gameType == .BotVsBot {
            isGameOver = true
            returnString = "BOT 1 gagne"
        } else if gameEngine.playerTwo.playerScore > numberOfRounds && gameEngine.gameType == .BotVsBot{
            isGameOver = true
            returnString = "BOT 2 gagne"
        }
        
        if isGameOver {
            if let gameDelegate = self.delegate {
                timer?.invalidate()
                self.dismiss(animated: true, completion: nil)
                gameEngine.resultString = returnString
                gameDelegate.didFinishPlayingGame(result: gameEngine)
            }
        }
        
        enableButtons()
        
    }
    
    //MARK:- Game Loop
    func startBotGameTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { (currTimer) in
            if let gameEngine = self.gameEngine {
                let botOneSelection = gameEngine.randomSelection()
                self.buttonTouchedActions(selection: botOneSelection)
            }
            
            self.checkGameStatus()
        }
        
    }
    
    func startTimer() {
        if let gameEngine = self.gameEngine {
            timerCount = gameEngine.waitingTime
            self.timerView.isHidden = false
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (currTimer) in
                if self.timerCount >= 0 {
                    self.timerLabel.text = "\(self.timerCount)"
                    self.timerCount -= 1
                } else {
                    print("timer stopped")
                    self.timerView.isHidden = true
                    self.timer?.invalidate()
                    if let gameEngine = self.gameEngine {
                        gameEngine.playerOneScored()
                    }
                    
                    self.updateGameScore()
                    self.timerCount = gameEngine.waitingTime
                    self.startTimer()
                }
                
                self.checkGameStatus()
            }
        }
        
    }
}
