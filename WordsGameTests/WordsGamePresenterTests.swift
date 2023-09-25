import XCTest

class WordsGamePresenterTests: XCTestCase {
    
    var mockView: MockPresenterView!
    var presenter: WordsGamePresenter!
    
    override func setUp() {
        super.setUp()
        mockView = MockPresenterView()
        presenter = WordsGamePresenter(with: mockView)
    }
    
    override func tearDown() {
        mockView = nil
        presenter = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(presenter.view)
        XCTAssertEqual(presenter.correctAttempts, 0)
        XCTAssertEqual(presenter.wrongAttempts, 0)
        XCTAssertEqual(presenter.currentPairIndex, 0)
        XCTAssertTrue(presenter.balancedList.isEmpty)
    }
    
    func testUserDidntGuessInTime() {
        let initialWrongAttempts = presenter.wrongAttempts
        presenter.userDidntGuessInTime()
        XCTAssertEqual(presenter.wrongAttempts, initialWrongAttempts + 1)
    }
    
    func testEvaluateCorrectAnswer() {
        let initialWrongAttempts = presenter.wrongAttempts
        let initialCorrectAttempts = presenter.correctAttempts
        presenter.evaluateAnswer(isCorrect: true)
        XCTAssertEqual(presenter.wrongAttempts, initialWrongAttempts)
        XCTAssertEqual(presenter.correctAttempts, initialCorrectAttempts + 1)
    }
    
    func testEvaluateWrongAnswer() {
        let initialWrongAttempts = presenter.wrongAttempts
        let initialCorrectAttempts = presenter.correctAttempts
        presenter.evaluateAnswer(isCorrect: false)
        XCTAssertEqual(presenter.wrongAttempts, initialWrongAttempts + 1)
        XCTAssertEqual(presenter.correctAttempts, initialCorrectAttempts)
    }

    
    func testStartNewGame() {
        presenter.correctAttempts = 5
        presenter.wrongAttempts = 3
        presenter.currentPairIndex = 10
        presenter.startNewGame()
        
        XCTAssertEqual(presenter.correctAttempts, 0)
        XCTAssertEqual(presenter.wrongAttempts, 0)
        XCTAssertEqual(presenter.currentPairIndex, 0)
    }
    
    func testCheckTheState_lostGame() {
        presenter.wrongAttempts = presenter.maxWrongAttemptsConst
        presenter.checkTheState()
        
        XCTAssertTrue(mockView.lostGame)
    }
    
    func testCheckTheState_wonGame() {
        presenter.wrongAttempts = 1
        presenter.correctAttempts = presenter.maxAttemptsConst - presenter.wrongAttempts
        presenter.checkTheState()
        
        XCTAssertFalse(mockView.lostGame)
    }
}

class MockPresenterView: PresenterView {
    var lostGame = false
    
    func updateCorrectLabelWithNumber(number: Int) {}
    
    func updateWrongLabelWithNumber(number: Int) {}
    
    func showSuccessEmoji() {}
    
    func showFailEmoji() {}
    
    func showNewPair() {}
    
    func stopTheGame(correctCount: Int, wrongCount: Int, isWin: Bool) {
        if (!isWin) {
            lostGame = true
        }
    }
}

