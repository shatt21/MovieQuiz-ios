//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Паша Шатовкин on 13.02.2024.
//

import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        //given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        //when
        let expectation = expectation(description: "Loading expectation")
        loader.loadMovies { result in
            //then
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        //given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        //when
        let expectation = expectation(description: "Loading expectation")
        loader.loadMovies { result in
            //then
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case.success(_):
                XCTFail("Unexpected failure")
            }
            
        }
        waitForExpectations(timeout: 1)
        
    }
}
