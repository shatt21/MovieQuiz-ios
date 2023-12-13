//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Паша Шатовкин on 18.10.2023.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    private var movies: [MostPopularMovie] = []
    private let moviesLoader: MoviesLoader
    private weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoader, delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movies = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movies.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movies.rating) ?? 0
            
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7
            
            let question = QuizeQuestion(image: imageData,
                                         text: text,
                                         correctAnswer: correctAnswer)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question)
            }
        }
    }
//    func requestNextQuestion() {
//        guard let question = question.randomElement() else {
//            assertionFailure("question is empty")
//            return
//        }
//        
//        delegate?.didReceiveNextQuestion(question)
//    }
}



//private let question: [QuizeQuestion] = [
//    QuizeQuestion(image: "The Godfather",
//                  text: "Рейтинг этого фильма больше чем 6?",
//                  correctAnswer: true),
//    QuizeQuestion(image: "The Dark Knight",
//                  text: "Рейтинг этого фильма больше чем 6?",
//                  correctAnswer: true),
//    QuizeQuestion(image: "Kill Bill",
//                  text: "Рейтинг этого фильма больше чем 6?",
//                  correctAnswer: true),
//    QuizeQuestion(image: "The Avengers",
//                  text: "Рейтинг этого фильма больше чем 6?",
//                  correctAnswer: true),
//    QuizeQuestion(image: "Deadpool",
//                  text: "Рейтинг этого фильма больше чем 6?",
//                  correctAnswer: true),
//    QuizeQuestion(image: "The Green Knight",
//                  text: "Рейтинг этого фильма больше чем 6?",
//                  correctAnswer: true),
//    QuizeQuestion(image: "Old",
//                  text: "Рейтинг этого фильма больше чем 6?",
//                  correctAnswer: false),
//    QuizeQuestion(image: "The Ice Age Adventures of Buck Wild",
//                  text: "Рейтинг этого фильма больше чем 6?",
//                  correctAnswer: false),
//    QuizeQuestion(image: "Tesla",
//                  text: "Рейтинг этого фильма больше чем 6?",
//                  correctAnswer: false),
//    QuizeQuestion(image: "Vivarium",
//                  text: "Рейтинг этого фильма больше чем 6?",
//                  correctAnswer: false)
//]
