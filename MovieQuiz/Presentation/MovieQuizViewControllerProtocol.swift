//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Паша Шатовкин on 13.02.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    
    func showQuestion(quiz step: QuizStepViewModel)
        
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showFinalAlert(quiz result: QuizResultsViewModel)
    
    func showErrorAlert(alertModel: AlertModel)
        
    func showLoadingIndicator()
    
    func hideLoadingIndicator()
    
    func switchOfButton()
}
