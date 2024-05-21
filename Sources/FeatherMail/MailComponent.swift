//
//  MailComponent.swift
//  FeatherMail
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import FeatherComponent

/// A protocol defining the requirements for a mail component.
public protocol MailComponent: Component {

    /// Sends an email.
    /// - Parameter email: The email to send.
    func send(_ email: Mail) async throws
}
