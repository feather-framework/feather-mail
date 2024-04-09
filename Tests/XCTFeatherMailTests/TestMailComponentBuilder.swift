//
//  MyMailComponentBuilder.swift
//  FeatherMailTests
//
//  Created by mzperx on 30/11/2023.
//

import FeatherComponent

struct TestMailComponentFactory: ComponentFactory {

    func build(using config: ComponentConfig) throws -> Component {
        TestMailComponent(config: config)
    }

}
