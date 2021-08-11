//
//  Google_Translate_SwiftUIUITests.swift
//  Google-Translate-SwiftUIUITests
//
//  Created by SCG on 8/8/21.
//

import XCTest

class Google_Translate_SwiftUIUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        
        // UI tests must launch the application that they test.
        app = XCUIApplication()
        app.launch()
    }

    func testUI() throws {
        
        // Home Screen
        let homeTab = app.tabBars["Tab Bar"].buttons["Home"]
        let headerLabel = app.staticTexts["Google Translate Clone"]
        let firstButton = app.buttons["English"]
        let secondButton = app.buttons["French"]
        let switchButton = app.buttons["arrow.right.arrow.left"]
        let textField = app.textFields["Enter text"]
        let deleteButton = app.buttons["multiply"]
        let translateButton = app.buttons["Right"]
        let homeFavorite = app.scrollViews.otherElements.containing(.staticText, identifier:"How are you?").children(matching: .button).matching(identifier: "favorite").element(boundBy: 0)

        // Language List
        let firstLabel = app.scrollViews.otherElements.buttons["Afrikaans"]
        let exitButton = app.buttons["multiply"]
        
        // Saved Screen
        let savedTab = app.tabBars["Tab Bar"].buttons["Saved"]
        let savedLabel = app.staticTexts["Saved"]
        let savedFavorite = app.scrollViews.otherElements.buttons["favorite"]

        
        if firstButton.isSelected || secondButton.isSelected {
            XCTAssertTrue(firstLabel.exists)
            XCTAssertTrue(firstLabel.isHittable)
            XCTAssertTrue(exitButton.exists)
            XCTAssertTrue(exitButton.isHittable)
        }
        
        if switchButton.isSelected {
            XCTAssertTrue(switchButton.exists)
            XCTAssertTrue(switchButton.isHittable)
        }
        
        if textField.isSelected {
            XCTAssertTrue(textField.exists)
            XCTAssertTrue(textField.isHittable)
        }
        
        if deleteButton.isSelected {
            XCTAssertTrue(deleteButton.exists)
            XCTAssertTrue(deleteButton.isHittable)
        }

        if translateButton.isSelected {
            XCTAssertTrue(translateButton.exists)
            XCTAssertTrue(translateButton.isHittable)
        }

        if savedTab.isSelected {
            XCTAssertTrue(savedLabel.exists)
            XCTAssertFalse(headerLabel.exists)
            XCTAssertTrue(savedFavorite.exists)
            XCTAssertTrue(savedFavorite.isHittable)

            homeTab.tap()
            XCTAssertTrue(headerLabel.exists)
            XCTAssertFalse(savedLabel.exists)
        } else if homeTab.isSelected {
            XCTAssertTrue(headerLabel.exists)
            XCTAssertFalse(savedLabel.exists)
            XCTAssertTrue(homeFavorite.exists)
            XCTAssertTrue(homeFavorite.isHittable)

            savedTab.tap()
            XCTAssertTrue(savedLabel.exists)
            XCTAssertFalse(headerLabel.exists)
        }
        
    }

    func testLaunchPerformance() throws {
        if #available(iOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
