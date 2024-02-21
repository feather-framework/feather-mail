//
//  MyMailComponent.swift
//  FeatherMailTests
//
//  Created by mzperx on 30/11/2023.
//

import FeatherComponent
import FeatherMail


enum TestMailComponentError: Error {

    case testError
}

struct TestMailComponent: MailComponent {

    var config: ComponentConfig
    var xctContext: TestMailComponentContext
    
    init(config: ComponentConfig) {
        self.config = config
        self.xctContext = config.context as! TestMailComponentContext
    }
    
    /// send an email
    func send(_ email: Mail) async throws {
        if self.xctContext.throwTestError {
            throw TestMailComponentError.testError
        }
    }
}
