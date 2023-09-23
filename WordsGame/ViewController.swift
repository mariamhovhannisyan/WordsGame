////
////  ViewController.swift
////  WordsGame
////
////  Created by Mar  Hovhannisyan on 22.09.23.
////
//
import UIKit
//
//
class ViewController: UIViewController {
//
//    var englishWordLabel = UILabel()
//    var spanishWordLabel = UILabel()
//    let buttonWidth = CGFloat(100)
//    let buttonHeight = CGFloat(30)
//    let safeArea = CGFloat(30) //:ToDo
//    let wrongAttemptsLabel = UILabel(frame: CGRect.zero)
//    let correctAttemptsLabel = UILabel(frame: CGRect.zero)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let correctButton = UIButton(frame: CGRect(x: safeArea , y: self.view.frame.height - buttonHeight - safeArea, width: buttonWidth, height: buttonHeight))
//
//        correctButton.setTitle("Correct", for: .normal)
//        correctButton.setTitleColor(.green, for: .normal)
//        correctButton.layer.borderColor = UIColor.green.cgColor
//        correctButton.layer.borderWidth = 0.5
//        correctButton.addTarget(self, action: #selector(correctButtonAction), for: .touchUpInside)
//
//        let wrongButton = UIButton(frame: CGRect(x: self.view.frame.width - buttonWidth - safeArea, y: self.view.frame.height - buttonHeight - safeArea, width: buttonWidth, height: buttonHeight))
//        wrongButton.setTitle("Wrong", for: .normal)
//        wrongButton.setTitleColor(.red, for: .normal)
//        wrongButton.layer.borderColor = UIColor.red.cgColor
//        wrongButton.layer.borderWidth = 0.5
//        wrongButton.addTarget(self, action: #selector(wrongButtonAction), for: .touchUpInside)
//
//        self.view.addSubview(correctButton)
//        self.view.addSubview(wrongButton)
//
//
//        self.correctAttemptsLabel.frame = CGRect(x: self.view.frame.width - buttonWidth*2 - safeArea, y: safeArea, width: buttonWidth*2, height: buttonHeight)
//        self.correctAttemptsLabel.text = "Correct attempts: \(self.user.correctAttempts)"
//
//        self.wrongAttemptsLabel.frame = CGRect(x: self.view.frame.width - buttonWidth*2 - safeArea, y: safeArea*2, width: buttonWidth*2, height: buttonHeight)
//        self.wrongAttemptsLabel.text = "Wrong attempts: \(self.user.wrongAttempts)"
//
//        self.view.addSubview(self.correctAttemptsLabel)
//        self.view.addSubview(self.wrongAttemptsLabel)
//
//        self.englishWordLabel = UILabel(frame: CGRect(x: 0 , y: 0, width: buttonWidth*2, height: buttonWidth*2))
//        self.view.addSubview(self.englishWordLabel)
//
//        self.englishWordLabel.center = self.view.center
//        self.englishWordLabel.text = vocab.randomEnglishWord()
//        self.englishWordLabel.textAlignment = .center
//        self.englishWordLabel.backgroundColor = .yellow
//
//
//        self.spanishWordLabel = UILabel(frame: CGRect(x: -buttonWidth*2 , y: -buttonWidth*2, width: buttonWidth*2, height: buttonWidth*2))
//        self.view.addSubview(self.spanishWordLabel)
//        self.spanishWordLabel.text = vocab.randomSpanishWord()
//        self.spanishWordLabel.center.x = self.view.center.x
//        self.spanishWordLabel.textAlignment = .center
//        self.spanishWordLabel.backgroundColor = .gray
//
//        self.showNewPair()
//
//    }
//
//    @objc func correctButtonAction(sender: UIButton!) { //:ToDo objc
//        let isCorrectAnswer = self.vocab.isCorrectTranslation(english: self.englishWordLabel.text!, spanish: self.spanishWordLabel.text!)
//        self.user.correctAttempts += isCorrectAnswer ? 1 : 0
//        if isCorrectAnswer {
//            let image = UIImage(named: "correct")
//            let imageView = UIImageView(image:image)
//            imageView.frame.size = CGSize(width: 50, height: 50)
//            self.view.addSubview(imageView)
//            imageView.center = self.view.center
//            UIView.animate(withDuration: 1.5, delay: 0, options: [.curveLinear]) {
//                imageView.alpha = 0
//            } completion: { _ in
//                imageView.removeFromSuperview()
//            }
//
//            self.user.correctAttempts += 1
//            self.correctAttemptsLabel.text = "Correct attempts: \(self.user.correctAttempts)"
//        } else {
//            let image = UIImage(named: "wrong")
//            let imageView = UIImageView(image:image)
//            imageView.frame.size = CGSize(width: 50, height: 50)
//            self.view.addSubview(imageView)
//            imageView.center = self.view.center
//            UIView.animate(withDuration: 1.5, delay: 0, options: [.curveLinear]) {
//                imageView.alpha = 0
//            } completion: { _ in
//                imageView.removeFromSuperview()
//            }
//            self.user.wrongAttempts += 1
//            self.wrongAttemptsLabel.text = "Wrong attempts: \(self.user.wrongAttempts)"
//        }
//        self.spanishWordLabel.layer.removeAllAnimations()
//        self.showNewPair()
//    }
//
//    @objc func wrongButtonAction(sender: UIButton!) {
//        let isCorrectAnswer = !self.vocab.isCorrectTranslation(english: self.englishWordLabel.text!, spanish: self.spanishWordLabel.text!)
//        if isCorrectAnswer {
//            let image = UIImage(named: "correct")
//            let imageView = UIImageView(image:image)
//            imageView.frame.size = CGSize(width: 30, height: 30)
//            self.view.addSubview(imageView)
//            imageView.center = self.view.center
//            UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear]) {
//                imageView.alpha = 0
//            } completion: { _ in
//                imageView.removeFromSuperview()
//            }
//
//            self.user.correctAttempts += 1
//            self.correctAttemptsLabel.text = "Correct attempts: \(self.user.correctAttempts)"
//        } else {
//            let image = UIImage(named: "wrong")
//            let imageView = UIImageView(image:image)
//            imageView.frame.size = CGSize(width: 30, height: 30)
//            self.view.addSubview(imageView)
//            imageView.center = self.view.center
//            UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear]) {
//                imageView.alpha = 0
//            } completion: { _ in
//                imageView.removeFromSuperview()
//            }
//            self.user.wrongAttempts += 1
//            self.wrongAttemptsLabel.text = "Wrong attempts: \(self.user.wrongAttempts)"
//        }
//        self.spanishWordLabel.layer.removeAllAnimations()
//        self.showNewPair()
//    }
//
//
//    func showNewPair() {
//        if self.user.wrongAttempts == 3 {
//            let alert = UIAlertController(title: "Better luck next time !", message: "Wrong attempts: \(self.user.wrongAttempts) \n Correct attempts: \(self.user.correctAttempts)", preferredStyle: .alert)
//            let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { action in
//                self.user.wrongAttempts = 0
//                self.user.correctAttempts = 0
//                self.correctAttemptsLabel.text = "Correct attempts: \(self.user.correctAttempts)"
//                //09107206 Lilit
//                self.wrongAttemptsLabel.text = "Wrong attempts: \(self.user.wrongAttempts)"
//                self.showNewPair()
//            })
//            alert.addAction(restartAction)
//            alert.addAction(UIAlertAction(title: "Close app", style: .default, handler: { action in
//                exit(0)
//            }))
//            present(alert, animated: true)
//        } else if self.user.wrongAttempts + self.user.correctAttempts == 15 {
//            let alert = UIAlertController(title: "Let's try another 15 pairs !", message: "Wrong attempts: \(self.user.wrongAttempts) \n Correct attempts: \(self.user.correctAttempts)", preferredStyle: .alert)
//            let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { action in
//                self.user.wrongAttempts = 0
//                self.user.correctAttempts = 0
//                self.correctAttemptsLabel.text = "Correct attempts: \(self.user.correctAttempts)"
//                //09107206 Lilit
//                self.wrongAttemptsLabel.text = "Wrong attempts: \(self.user.wrongAttempts)"
//                self.showNewPair()
//            })
//            alert.addAction(restartAction)
//            alert.addAction(UIAlertAction(title: "Close app", style: .cancel))
//            present(alert, animated: true)
//        } else {
//            self.englishWordLabel.text = vocab.randomEnglishWord()
//            self.spanishWordLabel.text = vocab.randomSpanishWord()
//            self.spanishWordLabel.frame = CGRect(x: -buttonWidth*2 , y: -buttonWidth*2, width: buttonWidth*2, height: buttonWidth*2)
//            self.spanishWordLabel.center.x = self.view.center.x
//            UIView.animate(withDuration: 5, delay: 0, options: [.curveEaseOut], animations: {
//                self.spanishWordLabel.center.y += self.view.bounds.height + self.buttonWidth*2
//            }, completion: { (finished) in
//                if finished {
//                    self.user.wrongAttempts += 1
//                    self.wrongAttemptsLabel.text = "Wrong attempts: \(self.user.wrongAttempts)"
//                    self.showNewPair()
//                }
//            })
//        }
//    }
//
}
//
