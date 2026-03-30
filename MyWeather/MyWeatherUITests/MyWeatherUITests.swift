//
//  MyWeatherUITests.swift
//  MyWeatherUITests
//
//  Created by Prasad Kukkala on 2/13/26.
//

import XCTest

final class MyWeatherUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.activate()
        app/*@START_MENU_TOKEN@*/.buttons["Login"]/*[[".otherElements.buttons[\"Login\"]",".buttons",".buttons[\"Login\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        let localAuthenticationUApp = XCUIApplication(bundleIdentifier: "com.apple.LocalAuthenticationUIService")
        localAuthenticationUApp/*@START_MENU_TOKEN@*/.keys["f"]/*[[".otherElements.keys[\"f\"]",".keys[\"f\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.doubleTap()
        localAuthenticationUApp/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".otherElements",".buttons[\"done\"]",".buttons[\"Done\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
                
    }
    
    func testEnterLocation() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        app.activate()
        app/*@START_MENU_TOKEN@*/.buttons["Login"]/*[[".otherElements.buttons[\"Login\"]",".buttons",".buttons[\"Login\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        let localAuthenticationUApp = XCUIApplication(bundleIdentifier: "com.apple.LocalAuthenticationUIService")
        localAuthenticationUApp.activate()
        localAuthenticationUApp/*@START_MENU_TOKEN@*/.keys["f"]/*[[".otherElements.keys[\"f\"]",".keys[\"f\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        localAuthenticationUApp/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".otherElements",".buttons[\"done\"]",".buttons[\"Done\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        app.activate()
        app/*@START_MENU_TOKEN@*/.buttons["Current Location"]/*[[".cells.buttons",".otherElements.buttons[\"Current Location\"]",".buttons[\"Current Location\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        let element = app/*@START_MENU_TOKEN@*/.buttons["BackButton"]/*[[".navigationBars",".buttons[\"Weather\"]",".buttons[\"BackButton\"]",".buttons"],[[[-1,2],[-1,1],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch
         element.tap()
        app.textFields["Enter City/State Code/Country"].firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.keys["A"]/*[[".otherElements.keys[\"A\"]",".keys[\"A\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.keys["u"]/*[[".otherElements.keys[\"u\"]",".keys[\"u\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".otherElements.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".otherElements.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.otherElements["Austin"]/*[[".otherElements.otherElements[\"Austin\"]",".otherElements[\"Austin\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".otherElements.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Austin, Texas"]/*[[".buttons",".containing(.staticText, identifier: \"Texas\")",".containing(.staticText, identifier: \"Austin\")",".otherElements.buttons[\"Austin, Texas\"]",".buttons[\"Austin, Texas\"]"],[[[-1,4],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        element.tap()
        
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
