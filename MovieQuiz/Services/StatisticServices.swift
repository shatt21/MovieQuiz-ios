//
//  StatisticServices.swift
//  MovieQuiz
//
//  Created by Паша Шатовкин on 19.10.2023.
//

import Foundation

protocol StatisticServices {
    var totalAccuracy: Double { get }
    var gameCount: Int { get }
    var bestGame: BestGame { get }
    
    func store(correct: Int, total: Int)
}

final class StatisticServicesImp {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults: UserDefaults
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let dateProvider: () -> Date
    
    init(userDefaults: UserDefaults = .standard,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder(),
         dateProvider: @escaping () -> Date = { Date() }
    ) {
        self.userDefaults = userDefaults
        self.decoder = decoder
        self.encoder = encoder
        self.dateProvider = dateProvider
    }
}

extension StatisticServicesImp: StatisticServices {
    
    
    var gameCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }

    
    var bestGame: BestGame  {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue), 
                  let record = try? decoder.decode(BestGame.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        set {
            guard let data = try? encoder.encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        if total == 0 {
            return 0
        }
       return Double(correct) / Double(total) * 100
    }
    
    func store(correct count: Int, total amount: Int) {
        self.correct += count
        self.total += amount
        self.gameCount += 1

        let game = BestGame(correct: count, total: amount, date: Date())

        if game.isBetterThan(bestGame) {
            bestGame = game
        }
    }
}
