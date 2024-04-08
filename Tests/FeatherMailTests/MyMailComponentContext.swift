//
//  MyMailComponentContext.swift
//  FeatherMailTests
//
//  Created by mzperx on 30/11/2023.
//

import FeatherComponent

struct MyMailComponentContext: ComponentContext {

    public func make() throws -> ComponentFactory {
        MyMailComponentFactory()
    }
}
