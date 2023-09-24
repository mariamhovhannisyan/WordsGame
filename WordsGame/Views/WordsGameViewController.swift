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
    var isGameInProgress = false
    
    var spanishWordLabel = UILabel()
    
    init() {
        super.init(nibName: "WordsGameViewController", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.polishUserInterface()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (!self.isGameInProgress) {
            self.presenter.startNewGame()
            self.isGameInProgress = true
        }
    }
    
    private func polishUserInterface() {
        self.englishWordLabel.textAlignment = .center
        self.englishWordLabel.backgroundColor = UIColor.init(hex: 0x746AB0)
        self.englishWordLabel.layer.borderColor = UIColor.black.cgColor
        self.englishWordLabel.layer.borderWidth = 1
        self.englishWordLabel.layer.cornerRadius = 8
        self.englishWordLabel.clipsToBounds = true
        self.correctAttemptsLabel.textAlignment = .center
        self.wrongAttemptsLabel.textAlignment = .center
        self.correctButton.layer.cornerRadius = self.correctButton.bounds.height/2
        self.correctButton.layer.shadowColor = UIColor.black.cgColor
        self.correctButton.layer.shadowOffset = CGSize(width: 8.0, height: 8.0)
        self.correctButton.layer.shadowRadius = 8
        self.correctButton.layer.shadowOpacity = 0.8
        self.wrongButton.layer.cornerRadius = self.wrongButton.bounds.height/2
        self.wrongButton.layer.shadowColor = UIColor.black.cgColor
        self.wrongButton.layer.shadowOffset = CGSize(width: 8.0, height: 8.0)
        self.wrongButton.layer.shadowRadius = 8
        self.wrongButton.layer.shadowOpacity = 0.8
        
        self.view.addSubview(self.spanishWordLabel)
        self.spanishWordLabel.textAlignment = .center
        self.spanishWordLabel.backgroundColor = .gray
        self.spanishWordLabel.layer.borderColor = UIColor.black.cgColor
        self.spanishWordLabel.layer.borderWidth = 1
        self.spanishWordLabel.layer.cornerRadius = 8
        self.spanishWordLabel.clipsToBounds = true
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
        self.showEmojiBasedOnAnswer(isCorrect: true)
    }
    
    func showFailEmoji() {
        self.showEmojiBasedOnAnswer(isCorrect: false)
    }
    
    private func showEmojiBasedOnAnswer(isCorrect: Bool) {
        let imageName = isCorrect ? "correct" : "wrong"
        let image = UIImage(named: imageName)
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
    
    func stopTheGame(correctCount: Int, wrongCount: Int, isWin: Bool) {
        self.spanishWordLabel.layer.removeAllAnimations()
        if !isWin {
            let alert = UIAlertController(title: "Better luck next time !", message: "Correct attempts: \(correctCount) \n Wrong attempts: \(wrongCount)", preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { action in
                self.presenter.startNewGame()
            })
            alert.addAction(restartAction)
            alert.addAction(UIAlertAction(title: "Close app", style: .default, handler: { action in
                exit(0)
            }))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Let's try another 15 pairs !", message: "Correct attempts: \(correctCount) \n Wrong attempts: \(wrongCount)", preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { action in
                self.presenter.startNewGame()
            })
            alert.addAction(restartAction)
            alert.addAction(UIAlertAction(title: "Close app", style: .default, handler: { action in
                exit(0)
            }))
            present(alert, animated: true)
        }
        
    }
    
    func showNewPair() {
        self.spanishWordLabel.layer.removeAllAnimations()
        self.englishWordLabel.text = self.presenter.getCurrentEnglishWord()
        self.spanishWordLabel.text = self.presenter.getCurrentSpanishWord()
        self.spanishWordLabel.frame = CGRect(x: -self.englishWordLabel.bounds.width , y: self.englishWordLabel.bounds.height, width: self.englishWordLabel.bounds.width, height: self.englishWordLabel.bounds.height)
        self.spanishWordLabel.center.x = self.view.center.x
        UIView.animate(withDuration: 5, delay: 0, options: [.curveLinear], animations: {
            self.spanishWordLabel.center.y += self.view.bounds.height + self.englishWordLabel.bounds.height*2
        }, completion: { (finished) in
            if finished {
                self.presenter.userDidntGuessInTime()
            }
        })
    }
}

        extension UIColor {

            convenience init(hex: Int) {
                let components = (
                    R: CGFloat((hex >> 16) & 0xff) / 255,
                    G: CGFloat((hex >> 08) & 0xff) / 255,
                    B: CGFloat((hex >> 00) & 0xff) / 255
                )
                self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
            }

        }
