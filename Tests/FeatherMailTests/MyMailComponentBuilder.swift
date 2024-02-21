//
//  MyMailComponentBuilder.swift
//  FeatherMailTests
//
//  Created by mzperx on 30/11/2023.
//

import FeatherComponent

struct MyMailComponentBuilder: ComponentBuilder {

    func build(using config: ComponentConfig) throws -> Component {
        MyMailComponent(config: config)
    }

}
