//
//  MyMailComponentContext.swift
//  FeatherMailTests
//
//  Created by mzperx on 30/11/2023.
//

import FeatherComponent

struct TestMailComponentContext: ComponentContext {

    let throwTestError: Bool

    func make() throws -> ComponentFactory {
        TestMailComponentFactory()
    }
}
