//
//  MyMailService.swift
//  FeatherMailTests
//
//  Created by mzperx on 30/11/2023.
//

import FeatherService
import FeatherMail


public enum XCTMailServiceError: Error {

    case testError
}

struct XCTMyMailService: MailService {

    var config: ServiceConfig
    var availableSpace: UInt64
    var xctContext: XCTMyMailServiceContext
    
    init(config: ServiceConfig, availableSpace: UInt64) {
        self.config = config
        self.availableSpace = availableSpace
        self.xctContext = config.context as! XCTMyMailServiceContext
    }
    
    /// send an email
    func send(_ email: Mail) async throws {
        if self.xctContext.isTestError {
            throw XCTMailServiceError.testError
        }
    }
}
