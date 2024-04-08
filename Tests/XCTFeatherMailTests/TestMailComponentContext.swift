//
//  MyMailComponentContext.swift
//  FeatherMailTests
//
//  Created by mzperx on 30/11/2023.
//

import FeatherComponent

struct TestMailComponentContext: ComponentContext {

    let throwTestError: Bool

    init(throwTestError: Bool) {
        self.throwTestError = throwTestError
    }

    public func make() throws -> ComponentFactory {
        TestMailComponentFactory()
    }
}
