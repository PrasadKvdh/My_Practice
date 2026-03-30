//
//  LoggingManager.swift
//  MyWeather
//
//  Created by Prasad Kukkala on 2/20/26.
//

import Foundation
import OSLog

enum currentModule: String {
    case logging
    case mainController
    case weather
    case search
    case forecast
}

protocol LoggerProtocol: AnyObject {
    func info(_ message: String)
    func warning(_ message: String)
    func error(_ message: String)
    func debug(_ message: String)
}

class LoggingManager: LoggerProtocol {
    
    private let logger = Logger(subsystem: "com.prasad.MyWeather", category: "MyWeather")
    
    func info(_ message: String) {
        logger.info("ℹ️ \(#fileID) \(#function) \(message, privacy: .public)")
    }
    
    func warning(_ message: String) {
        logger.warning("⚠️ \(message, privacy: .public)")
    }
    
    func error(_ message: String) {
        logger.error("🚨 \(message, privacy: .sensitive)")
    }
    
    func debug(_ message: String) {
        logger.debug("🐞 \(message, privacy: .auto)")
    }
}
