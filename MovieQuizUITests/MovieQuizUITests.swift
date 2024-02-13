//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Паша Шатовкин on 13.02.2024.
//

import XCTest

final class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testScreenCast() throws {
        app.buttons["Нет"].tap()
    }
    
    func testYesButton() {
        sleep(2)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        
        sleep(2)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPoster, secondPoster)
    }
    
    func testNoButton() {
        sleep(2)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(2)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation

        let indexLabel = app.staticTexts["Index"]
       
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testGameFinish() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        let alert = app.alerts["Game results"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раудн окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }
    
    func testAlertDissmiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Game results"]
            alert.buttons.firstMatch.tap()
            
            sleep(2)
            
            let indexLabel = app.staticTexts["Index"]
            
            XCTAssertFalse(alert.exists)
            XCTAssertTrue(indexLabel.label == "1/10")
    }
}
