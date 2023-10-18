//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Паша Шатовкин on 18.10.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(_ question: QuizeQuestion?)
}
