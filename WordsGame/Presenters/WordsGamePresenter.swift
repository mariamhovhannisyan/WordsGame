//
//  WordsGamePresenter.swift
//  WordsGame
//
//  Created by Mar  Hovhannisyan on 22.09.23.
//

import Foundation


struct TranslationPair {
    var textEng: String
    var textSpa: String
}



struct Dictionary {
    
    var wordPairs: [TranslationPair]
    private var wordPairsDict: [String:String]
    
    
    init() {
        let result = Dictionary.getPairsfromJson()
        self.wordPairs = result.0
        self.wordPairsDict = result.1
    }
    
    static private func getPairsfromJson() -> ([TranslationPair], [String: String]) {
        var result: [TranslationPair] = []
        var dictResult: [String:String] = [:]
        if let url = Bundle.main.url(forResource: "words", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                if let jsonArray = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? [[String : String]] {
                    for dict in jsonArray {
                        dictResult[dict["text_eng"] ?? ""] = dict["text_spa"]
                        let pair = TranslationPair(textEng: dict["text_eng"] ?? "", textSpa: dict["text_spa"] ?? "")
                        result.append(pair)
                    }
                }
            }
            catch {
                print(error)
            }
        }
        return (result, dictResult)
    }
    
    
    func doTheseWordsTranslateEachOther(english: String, spanish: String) -> Bool {
        return self.wordPairsDict[english] == spanish
    }
}

protocol PresenterView: AnyObject {
    func showNewPair()
    func stopTheGame(correctCount: Int, wrongCount: Int)
    func showSuccessEmoji()
    func showFailEmoji()
    func updateCorrectLabelWithNumber(number :Int)
    func updateWrongLabelWithNumber(number :Int)
    
}

class WordsGamePresenter {
    weak var view: PresenterView?
    var dict = Dictionary()
    var currentPairIndex = 0
    let maxAttemptsConst = 15
    let probabilityConst = 0.25
    let maxWrongAttemptsConst = 3
    var balancedList: [TranslationPair]
    
    
    var correctAttempts = 0 {
        didSet {
            self.view?.updateCorrectLabelWithNumber(number: correctAttempts)
        }
    }
    
    var wrongAttempts = 0 {
        didSet {
            self.view?.updateWrongLabelWithNumber(number: wrongAttempts)
        }
    }
    
    init(with view: PresenterView) {
        self.view = view
        let shuffledPairs = self.dict.wordPairs.shuffled()
        //let numCorrectPairs = Int((Double(shuffledPairs.count) * probabilityConst).rounded(.up))
        let maxAttemptsBalance = Int((Double(self.maxAttemptsConst) * 0.25).rounded(.up))
        let selectedCorrectPairs = Array(shuffledPairs.prefix(maxAttemptsBalance))
        var selectedIncorrectPairs = [TranslationPair]()
        
        for _ in 0..<self.maxAttemptsConst-maxAttemptsBalance {
            let randomEnglishIndex = Int.random(in: maxAttemptsBalance..<shuffledPairs.count)
            var randomSpanishIndex = Int.random(in: maxAttemptsBalance..<shuffledPairs.count)
            while randomSpanishIndex == randomEnglishIndex {
                randomSpanishIndex = Int.random(in: maxAttemptsBalance..<shuffledPairs.count)
            }
            
            let pair = TranslationPair(textEng: shuffledPairs[randomEnglishIndex].textEng,textSpa: shuffledPairs[randomSpanishIndex].textSpa)
            selectedIncorrectPairs.append(pair)
        }
        
        self.balancedList = Array(selectedCorrectPairs + selectedIncorrectPairs).shuffled()
    }
    
    func userDidntGuessInTime() {
        self.wrongAttempts += 1
        self.checkTheState()
    }
    
    func wrongButtonTapped() {
        let isCorrectAnswer = !self.dict.doTheseWordsTranslateEachOther(english: self.getCurrentEnglishWord(), spanish: self.getCurrentSpanishWord())
        if isCorrectAnswer {
            self.view?.showSuccessEmoji()
            self.correctAttempts += 1
        } else {
            self.view?.showFailEmoji()
            self.wrongAttempts += 1
        }
        self.checkTheState()
    }
    
    func correctButtonTapped() {
        let isCorrectAnswer = self.dict.doTheseWordsTranslateEachOther(english: self.getCurrentEnglishWord(), spanish: self.getCurrentSpanishWord())
        if isCorrectAnswer {
            self.view?.showSuccessEmoji()
            self.correctAttempts += 1
        } else {
            self.view?.showFailEmoji()
            self.wrongAttempts += 1
        }
        self.checkTheState()
    }
    
    func resetTheState() {
        self.wrongAttempts = 0
        self.correctAttempts = 0
        self.currentPairIndex = 0
        self.view?.showNewPair()
    }
    
    private func checkTheState() {
        if self.wrongAttempts == self.maxWrongAttemptsConst || self.wrongAttempts + self.correctAttempts == self.maxAttemptsConst {
            self.view?.stopTheGame(correctCount: self.correctAttempts, wrongCount: self.wrongAttempts)
        } else {
            self.currentPairIndex += 1
            self.view?.showNewPair()
        }
    }
    
    func getCurrentEnglishWord() -> String {
        return self.balancedList[self.currentPairIndex].textEng
    }
    
    func getCurrentSpanishWord() -> String {
        return self.balancedList[self.currentPairIndex].textSpa
    }
}
