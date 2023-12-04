//
//  MyMailServiceBuilder.swift
//  FeatherMailTests
//
//  Created by mzperx on 30/11/2023.
//

import FeatherService

struct MyMailServiceBuilder: ServiceBuilder {

    func build(using config: ServiceConfig) throws -> Service {
        MyMailService(config: config)
    }

}
