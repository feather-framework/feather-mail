//
//  MyMailServiceContext.swift
//  FeatherMailTests
//
//  Created by mzperx on 30/11/2023.
//

import FeatherService

struct TestMailServiceContext: ServiceContext {

    let throwTestError: Bool
    
    init(throwTestError: Bool) {
        self.throwTestError = throwTestError
    }
    
    public func make() throws -> ServiceBuilder {
        TestMailServiceBuilder()
    }
}
