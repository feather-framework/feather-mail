//
//  MyMailComponentBuilder.swift
//  FeatherMailTests
//
//  Created by mzperx on 30/11/2023.
//

import FeatherComponent

struct MyMailComponentFactory: ComponentFactory {

    func build(using config: ComponentConfig) throws -> Component {
        MyMailComponent(config: config)
    }

}
