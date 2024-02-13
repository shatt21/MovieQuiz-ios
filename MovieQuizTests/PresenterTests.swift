//
//  PresenterTests.swift
//  MovieQuizTests
//
//  Created by Паша Шатовкин on 13.02.2024.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showQuestion(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    func showFinalAlert(quiz result: MovieQuiz.QuizResultsViewModel) {
        
    }
    
    func showErrorAlert(alertModel: MovieQuiz.AlertModel) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func switchOfButton() {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws{
        let viewControllerMock = MovieQuizViewController()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizeQuestion(image: emptyData, text: "Question text", correctAnswer: true)
        let viewModel = sut.convert(question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
