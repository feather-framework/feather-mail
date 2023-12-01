//
//  MyMailServiceContext.swift
//  FeatherMailTests
//
//  Created by mzperx on 30/11/2023.
//

import FeatherService

public struct MyMailServiceContext: ServiceContext {

    public func make() throws -> ServiceBuilder {
        MyMailServiceBuilder()
    }
}
