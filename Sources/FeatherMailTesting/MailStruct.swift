//
//  MailStruct.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 01. 06..
//

import FeatherMail

/// A concrete implementation of `MailProtocol` used primarily for testing or as a no-op placeholder.
public struct MailStruct: MailProtocol {

    /// Simulates the sending of an email.
    ///
    /// In this implementation, the function performs no action, serving as a "mock"
    /// that fulfills the protocol requirements without requiring a real mail server.
    ///
    /// - Parameter email: The validated `Mail` object to be "sent".
    /// - Throws: This implementation does not currently throw, but conforms to the async throws requirement of `MailProtocol`.
    public func send(_ email: Mail) async throws(MailError) {
        // do nothing
    }

}
