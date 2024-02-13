//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Паша Шатовкин on 13.02.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    

    private var currentQuestionIndex: Int = 0
    let questionsAmount: Int = 10
    private var correctAnswers = 0
    
    var currentQuestion: QuizeQuestion?
    private var statisticService: StatisticServices?
    private var questionFactory: QuestionFactoryProtocol?
    
    weak var viewController: MovieQuizViewController?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServicesImp()
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    
    func convert(_ model: QuizeQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    func noButtonClicked() {
        didAnswer(isCorrectAnswer: false)
        }
    
    func yesButtonClicked() {
        didAnswer(isCorrectAnswer: true)
    }
    
    
    func didAnswer(isCorrectAnswer: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = isCorrectAnswer
        if givenAnswer == currentQuestion.correctAnswer {
            proccedWithAnswer(isCorrect: true)
            correctAnswers += 1
        } else {
            proccedWithAnswer(isCorrect: false)
        }
    }
    
    
    
    
// MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.hideLoadingIndicator()
        let alertModel = AlertModel(
            title: "Error",
            message: "error",
            buttonText: "Try again",
            completion: {[weak self] in
                guard let self = self else { return }
                self.questionFactory?.loadData()
            }
        )
        viewController?.showErrorAlert(alertModel: alertModel)
    }
    
    func didFailLoadImage() {
        viewController?.hideLoadingIndicator()
        let alertModel = AlertModel(
            title: "Ошибка",
            message: "Не удалось загрузить фото",
            buttonText: "Загрузить другой вопрос?",
            completion: {[weak self] in
                guard let self = self else { return }
                self.didLoadDataFromServer()
            }
        )
        viewController?.showErrorAlert(alertModel: alertModel)
    }
    
    func didReceiveNextQuestion(_ question: QuizeQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showQuestion(quiz: viewModel)
        }
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()

    }
    
    func proccedWithAnswer(isCorrect: Bool) {
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proccedToNextQuestionOrResult()
        }
    }
    
    func proccedToNextQuestionOrResult() {
        if isLastQuestion(){
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            let viewModel = QuizResultsViewModel(
                title: "Игра окончена",
                text: makeResultMessage(),
                buttonText: "Сыграть еще раз")
            viewController?.showFinalAlert(quiz: viewModel)
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()

            
            
        }
    }
    
    func makeResultMessage() -> String {
        guard let statisticService = statisticService else {
            assertionFailure("error message")
            return ""
        }
        
        let resultMessage = """
        Ваш результат: \(correctAnswers)/\(questionsAmount)
        Количество сыгранных квизов: \(statisticService.gameCount)
        Лучший результат: \(statisticService.bestGame.correct)/10 (\(statisticService.bestGame.date.dateTimeString))
        Cредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        """
        return resultMessage
    }
}

