//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Паша Шатовкин on 18.10.2023.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {

    private weak var delegate: QuestionFactoryDelegate?
    
    init(delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
    }
    
    func requestNextQuestion() {
        guard let question = question.randomElement() else {
            assertionFailure("question is empty")
            return
        }
        
        delegate?.didReceiveNextQuestion(question)
    }
}


private let question: [QuizeQuestion] = [
    QuizeQuestion(image: "The Godfather",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
    QuizeQuestion(image: "The Dark Knight",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
    QuizeQuestion(image: "Kill Bill",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
    QuizeQuestion(image: "The Avengers",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
    QuizeQuestion(image: "Deadpool",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
    QuizeQuestion(image: "The Green Knight",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
    QuizeQuestion(image: "Old",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: false),
    QuizeQuestion(image: "The Ice Age Adventures of Buck Wild",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: false),
    QuizeQuestion(image: "Tesla",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: false),
    QuizeQuestion(image: "Vivarium",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: false)
]
