//
//  MyMailServiceBuilder.swift
//  FeatherMailTests
//
//  Created by mzperx on 30/11/2023.
//

import FeatherService

struct TestMailServiceBuilder: ServiceBuilder {

    func build(using config: ServiceConfig) throws -> Service {
        TestMailService(config: config)
    }

}
