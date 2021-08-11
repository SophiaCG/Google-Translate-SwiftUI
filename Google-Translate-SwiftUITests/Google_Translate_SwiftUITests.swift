//
//  Google_Translate_SwiftUITests.swift
//  Google-Translate-SwiftUITests
//
//  Created by SCG on 8/8/21.
//

import XCTest
@testable import Google_Translate_SwiftUI

class APITests: XCTestCase {
    
    var sut: URLSession!
    let networkMonitor = NetworkMonitor.shared
    let viewModel = ViewModel()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = URLSession(configuration: .default)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testValidListAPI() throws {
        try XCTSkipUnless(
            networkMonitor.isReachable,
            "Network connectivity needed for this test.")
        
        // given
        let urlString = "https://google-translate1.p.rapidapi.com/language/translate/v2/languages?target=en&rapidapi-key=\(viewModel.apiKey)"
        let url = URL(string: urlString)!
        
        // 1. expectation(description:): Returns XCTestExpectation, stored in promise. description describes what you expect to happen
        let promise = expectation(description: "Status code: 200")
        
        // when
        let dataTask = sut.dataTask(with: url) { _, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2. promise.fulfill(): Call this in the success condition closure of the asynchronous method’s completion handler to flag that the expectation has been met
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        // 3. wait(for:timeout:): Keeps the test running until all expectations are fulfilled or the timeout interval ends, whichever happens first
        wait(for: [promise], timeout: 5)
    }
    
    // Asynchronous test: faster fail
    func testListAPICallCompletes() throws {
        try XCTSkipUnless(
            networkMonitor.isReachable,
            "Network connectivity needed for this test."
        )
        
        // given
        let urlString = "https://google-translate1.p.rapidapi.com/language/translate/v2/languages?target=en&rapidapi-key=\(viewModel.apiKey)"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sut.dataTask(with: url) { _, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
 
    func testValidTranslationAPI() throws {
        try XCTSkipUnless(
            networkMonitor.isReachable,
            "Network connectivity needed for this test.")
        
        // given
        let urlString = "https://google-translate20.p.rapidapi.com/translate?text=hello&sl=en&tl=fr&rapidapi-key=\(viewModel.apiKey)"
        let url = URL(string: urlString)!
        
        // 1. expectation(description:): Returns XCTestExpectation, stored in promise. description describes what you expect to happen
        let promise = expectation(description: "Status code: 200")
        
        // when
        let dataTask = sut.dataTask(with: url) { _, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2. promise.fulfill(): Call this in the success condition closure of the asynchronous method’s completion handler to flag that the expectation has been met
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        // 3. wait(for:timeout:): Keeps the test running until all expectations are fulfilled or the timeout interval ends, whichever happens first
        wait(for: [promise], timeout: 5)
    }
    
    // Asynchronous test: faster fail
    func testTranslationAPICallCompletes() throws {
        try XCTSkipUnless(
            networkMonitor.isReachable,
            "Network connectivity needed for this test."
        )
        
        // given
        let urlString = "https://google-translate20.p.rapidapi.com/translate?text=hello&sl=en&tl=fr&rapidapi-key=\(viewModel.apiKey)"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sut.dataTask(with: url) { _, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

}
