//
//  MyMailServiceBuilder.swift
//  FeatherMailTests
//
//  Created by mzperx on 30/11/2023.
//

import FeatherService

struct XCTMyMailServiceBuilder: ServiceBuilder {

    func build(using config: ServiceConfig) throws -> Service {
        XCTMyMailService(config: config, availableSpace: 0)
    }

}
