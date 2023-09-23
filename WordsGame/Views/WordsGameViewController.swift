//
//  WordsGameViewController.swift
//  WordsGame
//
//  Created by Mar  Hovhannisyan on 22.09.23.
//

import UIKit

class WordsGameViewController: UIViewController {
    
    @IBOutlet weak var correctAttemptsLabel: UILabel!
    @IBOutlet weak var wrongAttemptsLabel: UILabel!
    @IBOutlet weak var englishWordLabel: UILabel!
    @IBOutlet weak var correctButton: UIButton!
    @IBOutlet weak var wrongButton: UIButton!
    
    lazy var presenter = WordsGamePresenter(with: self)
    let buttonWidth = CGFloat(100)
    
    var spanishWordLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.englishWordLabel.textAlignment = .center
        self.englishWordLabel.backgroundColor = .yellow
        self.englishWordLabel.layer.borderColor = UIColor.black.cgColor
        self.englishWordLabel.layer.borderWidth = 1
        self.correctAttemptsLabel.textAlignment = .center
        self.wrongAttemptsLabel.textAlignment = .center
        self.correctButton.layer.cornerRadius = self.correctButton.bounds.height/2
        self.wrongButton.layer.cornerRadius = self.wrongButton.bounds.height/2
        
        self.view.addSubview(self.spanishWordLabel)
        self.spanishWordLabel.textAlignment = .center
        self.spanishWordLabel.backgroundColor = .gray
        self.spanishWordLabel.layer.borderColor = UIColor.black.cgColor
        self.spanishWordLabel.layer.borderWidth = 1
        self.presenter.resetTheState()
    }
    
    @IBAction func correctButtonClicked(_ sender: Any) {
        self.presenter.correctButtonTapped()
    }
    
    @IBAction func wrongButtonClicked(_ sender: Any) {
        self.presenter.wrongButtonTapped()
    }
}

extension WordsGameViewController: PresenterView {
    func showSuccessEmoji() {
        let image = UIImage(named: "correct")
        let imageView = UIImageView(image:image)
        let sizeConstant = CGFloat(40)
        imageView.frame.size = CGSize(width: sizeConstant, height: sizeConstant)
        self.view.addSubview(imageView)
        imageView.center = self.view.center
        imageView.center.y -= sizeConstant
        imageView.contentMode = .scaleAspectFit
        UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear]) {
            imageView.alpha = 0
            imageView.center.y += sizeConstant/2
        } completion: { _ in
            imageView.removeFromSuperview()
        }
    }
    
    func showFailEmoji() {
        let image = UIImage(named: "wrong")
        let imageView = UIImageView(image:image)
        let sizeConstant = CGFloat(40)
        imageView.frame.size = CGSize(width: sizeConstant, height: sizeConstant)
        self.view.addSubview(imageView)
        imageView.center = self.view.center
        imageView.center.y -= sizeConstant
        imageView.contentMode = .scaleAspectFit
        UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear]) {
            imageView.alpha = 0
            imageView.center.y += sizeConstant/2
        } completion: { _ in
            imageView.removeFromSuperview()
        }
    }
    
    func updateCorrectLabelWithNumber(number: Int) {
        self.correctAttemptsLabel.text = "Correct attempts: \(number)"
    }
    
    func updateWrongLabelWithNumber(number: Int) {
        self.wrongAttemptsLabel.text = "Wrong attempts: \(number)"
    }
    
    func stopTheGame(correctCount: Int, wrongCount: Int) {
        self.spanishWordLabel.layer.removeAllAnimations()
        if wrongCount == 3 {
            let alert = UIAlertController(title: "Better luck next time !", message: "Correct attempts: \(correctCount) \n Wrong attempts: \(wrongCount)", preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { action in
                self.presenter.resetTheState()
            })
            alert.addAction(restartAction)
            alert.addAction(UIAlertAction(title: "Close app", style: .default, handler: { action in
                exit(0)
            }))
            present(alert, animated: true)
        } else if wrongCount + correctCount == 15 {
            let alert = UIAlertController(title: "Let's try another 15 pairs !", message: "orrect attempts: \(correctCount) \n Wrong attempts: \(wrongCount)", preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { action in
                self.presenter.resetTheState()
            })
            alert.addAction(restartAction)
            alert.addAction(UIAlertAction(title: "Close app", style: .cancel))
            present(alert, animated: true)
        }
        
    }
    
    func showNewPair() {
        self.spanishWordLabel.layer.removeAllAnimations()
        self.englishWordLabel.text = self.presenter.getCurrentEnglishWord()
        self.spanishWordLabel.text = self.presenter.getCurrentSpanishWord()
        self.spanishWordLabel.frame = CGRect(x: -buttonWidth*2 , y: -buttonWidth, width: buttonWidth*2, height: buttonWidth/2)
        self.spanishWordLabel.center.x = self.view.center.x
        UIView.animate(withDuration: 5, delay: 0, options: [.curveLinear], animations: {
            self.spanishWordLabel.center.y += self.view.bounds.height + self.buttonWidth*2
        }, completion: { (finished) in
            if finished {
                self.presenter.userDidntGuessInTime()
            }
        })
    }
}
