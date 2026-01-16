//
//  MailProtocol.swift
//  feather-mail
//
//  Created by Tibor Bödecs on 2023. 01. 16..
//

/// A protocol defining a mail delivery mechanism.
public protocol MailProtocol: Sendable {

    /// Sends the specified mail asynchronously.
    ///
    /// - Parameter email: A `Mail` instance to be delivered.
    /// - Throws: `MailError` if delivery fails.
    func send(_ email: Mail) async throws(MailError)
}
