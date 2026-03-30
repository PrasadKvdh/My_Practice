//
//  NetworkManager.swift
//  Weather
//
//  Created by Prasad Kukkala on 2/5/26.
//

import Foundation

enum AppSecrets {
    static var weatherApIKey: String {
//        guard let key = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String, !key.isEmpty else {
//            fatalError("WEATHER_API_KEY not configured")
//        }
        return "df09fd8e7691ee7b3e4a3d604a874da8"
    }
}

enum NetworkError: LocalizedError {
    case noDataAvailable
    case decodeError
    case badResponse
    case exceedAttemptsLimit
    case invalidUrl
    
    var errorDescription: String? {
        switch self {
        case .noDataAvailable:
            return "No data available."
        case .decodeError:
            return "Unable to decode data."
        case .exceedAttemptsLimit:
            return "Exceed attempts limit."
        case .badResponse:
            return "Bad response."
        case .invalidUrl:
            return "Invalid URL."
        }
    }
}

final class NetworkManager: NSObject {
    let pinConfig = PinningConfiguration(allowedSPKIHashes: ["PRIMARY_HASH_BASE64", "BACKUP_HASH_BASE64"])
    
    //let delegate = PinningURLSessionDelegate(config: pinConfig)
    
    let logger: LoggingManager
    let session: URLSession = {
        //Session Configuration setup
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.urlCache = nil
        sessionConfig.timeoutIntervalForRequest = 10
        
        //Create global session
        return URLSession(configuration: sessionConfig)
    }()
    
    init(logger: LoggingManager) {
        self.logger = logger
    }
    
    func fetchRequest<T: Decodable>(requestUrl: URL, type: T.Type) async throws -> T {
        
        let data = try await processRequest(url: requestUrl)
        //Decode server response
        do {
            logger.debug("Parsing data success")
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            logger.error("Parsing error: \(error)")
            throw NetworkError.decodeError
        }
    }
        
    func processRequest(url: URL) async throws -> Data {
        //Fetch Data from server
        logger.error("Fetching from \(url)")
        let (data, serverResponse) = try await session.data(from: url)
        
        guard let response = serverResponse as? HTTPURLResponse,
              200..<300 ~= response.statusCode else {
            logger.error("Fetch request get error response")
            throw NetworkError.badResponse
        }
                
        guard !data.isEmpty else {
            logger.error("Got empty response")
            throw NetworkError.noDataAvailable
        }
        
        logger.info("Received server response")
        return data
    }
    
    func retry<T>(maxAttempts: Int, baseDelay: Double, operation: @escaping () async throws -> T) async throws -> T {
        var attempt = 0
        
        while true {
            do {
                //Fetch request
                return try await operation()
            } catch {
                attempt += 1
                
                //Validating attempts of retry API request
                guard attempt > maxAttempts else {
                    throw NetworkError.exceedAttemptsLimit
                }
                
                //Delay + jitter
                let delay = UInt64(pow(2.0, Double(attempt))) * 30
                let jitter = Double.random(in: -2.0...2.0)
                try await Task.sleep(nanoseconds: delay + UInt64(jitter))
            }
        }
    }
}

struct PinningConfiguration {
    let allowedSPKIHashes: Set<String>
}

final class PinningURLSessionDelegate: NSObject, URLSessionDelegate {
    
    private let config: PinningConfiguration
    
    init(config: PinningConfiguration) {
        self.config = config
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let trust = challenge.protectionSpace.serverTrust else {
            return (.performDefaultHandling, nil)
        }

        // Attempt to get the server certificate
        guard let serverCertificate = SecTrustCopyCertificateChain(trust) else {
            return (.cancelAuthenticationChallenge, nil)
        }

        // Extract the public key from the certificate
        guard let serverKey = SecCertificateCopyKey(serverCertificate as! SecCertificate) else {
            return (.cancelAuthenticationChallenge, nil)
        }

        // Extract key bytes; this returns CFData which we bridge to Data
        guard let serverKeyDataCF = SecKeyCopyExternalRepresentation(serverKey, nil) else {
            return (.cancelAuthenticationChallenge, nil)
        }

        let serverKeyData = serverKeyDataCF as Data
        let hash = serverKeyData.base64EncodedString()

        // TODO: Compare `hash` against your pinned key/certificate hash if implementing SSL pinning.
        // For now, perform default handling so the system validates the trust chain.
        
        
        return (.performDefaultHandling, nil)
    }
}

actor Deduplicator {
    private var inFlightTasks: [String: Task<Data, Error>] = [:]
}
