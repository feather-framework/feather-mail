//
//  MailComponent.swift
//  FeatherMail
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import FeatherComponent

/// the mail component protocol
public protocol MailComponent: Component {

    /// send an email
    func send(_ email: Mail) async throws
}
