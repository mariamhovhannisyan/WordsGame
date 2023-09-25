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
                        let english = dict["text_eng"] ?? ""
                        let spanish = dict["text_spa"] ?? ""
                        dictResult[english] = spanish
                        let pair = TranslationPair(textEng: english, textSpa: spanish)
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
    func stopTheGame(correctCount: Int, wrongCount: Int, isWin: Bool)
    func showSuccessEmoji()
    func showFailEmoji()
    func updateCorrectLabelWithNumber(number :Int)
    func updateWrongLabelWithNumber(number :Int)
    
}

class WordsGamePresenter {
    weak var view: PresenterView?
    var dict = Dictionary()
    var setForEnglishIndexes: Set<Int> = []
    var currentPairIndex = 0
    let maxAttemptsConst = 15
    let probabilityConst = 0.25
    let maxWrongAttemptsConst = 3
    var balancedList = [TranslationPair]()
    
    
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
    }
    
    func getBalancedList() ->  [TranslationPair] {
        let shuffledPairs = self.dict.wordPairs.shuffled()
        //let correctAttemptsCount = Int((Double(shuffledPairs.count) * probabilityConst).rounded(.up)) :The count for the whole list
        let correctAttemptsCount = Int((Double(self.maxAttemptsConst) * probabilityConst).rounded(.up))
        let selectedCorrectPairs = Array(shuffledPairs.prefix(correctAttemptsCount))
        var selectedIncorrectPairs = [TranslationPair]()
        
        for _ in 0..<self.maxAttemptsConst-correctAttemptsCount {
            var randomEnglishIndex = Int.random(in: correctAttemptsCount..<shuffledPairs.count)
            while self.setForEnglishIndexes.contains(randomEnglishIndex) { // for excluding the same english word to appear in the list
                randomEnglishIndex = Int.random(in: correctAttemptsCount..<shuffledPairs.count)
            }
            self.setForEnglishIndexes.insert(randomEnglishIndex)
            var randomSpanishIndex = Int.random(in: correctAttemptsCount..<shuffledPairs.count)
            while randomSpanishIndex == randomEnglishIndex { // for excluding a correct word pair to appear in the list
                randomSpanishIndex = Int.random(in: correctAttemptsCount..<shuffledPairs.count)
            }
            
            let pair = TranslationPair(textEng: shuffledPairs[randomEnglishIndex].textEng,textSpa: shuffledPairs[randomSpanishIndex].textSpa)
            selectedIncorrectPairs.append(pair)
        }
        return Array(selectedCorrectPairs + selectedIncorrectPairs).shuffled()
    }
    
    func userDidntGuessInTime() {
        self.evaluateAnswer(isCorrect: false)
    }
    
    func wrongButtonTapped() {
        let isCorrectAnswer = !self.dict.doTheseWordsTranslateEachOther(english: self.getCurrentEnglishWord(), spanish: self.getCurrentSpanishWord())
        self.evaluateAnswer(isCorrect: isCorrectAnswer)
    }
    
    func correctButtonTapped() {
        let isCorrectAnswer = self.dict.doTheseWordsTranslateEachOther(english: self.getCurrentEnglishWord(), spanish: self.getCurrentSpanishWord())
        self.evaluateAnswer(isCorrect: isCorrectAnswer)
    }
    
    func evaluateAnswer(isCorrect: Bool) {
        if (isCorrect) {
            self.view?.showSuccessEmoji()
            self.correctAttempts += 1
        } else {
            self.view?.showFailEmoji()
            self.wrongAttempts += 1
        }
        self.checkTheState()
    }
    
    func startNewGame() {
        self.wrongAttempts = 0
        self.correctAttempts = 0
        self.currentPairIndex = 0
        self.setForEnglishIndexes = []
        self.balancedList = self.getBalancedList()
        self.view?.showNewPair()
    }
    
    func checkTheState() {
        if self.wrongAttempts == self.maxWrongAttemptsConst {
            self.view?.stopTheGame(correctCount: self.correctAttempts, wrongCount: self.wrongAttempts, isWin: false)
        } else if self.wrongAttempts + self.correctAttempts == self.maxAttemptsConst {
            self.view?.stopTheGame(correctCount: self.correctAttempts, wrongCount: self.wrongAttempts, isWin: true)
        } else {
            self.currentPairIndex += 1
            self.view?.showNewPair()
        }
    }
    
    func getCurrentEnglishWord() -> String {
        guard self.balancedList.count >= self.currentPairIndex else {return ""}
        return self.balancedList[self.currentPairIndex].textEng
    }
    
    func getCurrentSpanishWord() -> String {
        guard self.balancedList.count >= self.currentPairIndex else {return ""}
        return self.balancedList[self.currentPairIndex].textSpa
    }
}
