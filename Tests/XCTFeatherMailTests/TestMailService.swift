//
//  MyMailService.swift
//  FeatherMailTests
//
//  Created by mzperx on 30/11/2023.
//

import FeatherService
import FeatherMail


enum TestMailServiceError: Error {

    case testError
}

struct TestMailService: MailService {

    var config: ServiceConfig
    var xctContext: TestMailServiceContext
    
    init(config: ServiceConfig) {
        self.config = config
        self.xctContext = config.context as! TestMailServiceContext
    }
    
    /// send an email
    func send(_ email: Mail) async throws {
        if self.xctContext.throwTestError {
            throw TestMailServiceError.testError
        }
    }
}
