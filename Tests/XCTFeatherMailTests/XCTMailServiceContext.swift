//
//  MyMailServiceContext.swift
//  FeatherMailTests
//
//  Created by mzperx on 30/11/2023.
//

import FeatherService

public struct XCTMyMailServiceContext: ServiceContext {

    let isTestError: Bool
    
    init(isTestError: Bool) {
        self.isTestError = isTestError
    }
    
    public func make() throws -> ServiceBuilder {
        XCTMyMailServiceBuilder()
    }
}
