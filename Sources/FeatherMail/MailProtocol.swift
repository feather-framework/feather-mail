//
//  MailProtocol.swift
//  feather-mail
//
//  Created by Tibor Bödecs on 2023. 01. 16..
//

/// A protocol that defines the requirements for a mail delivery service.
///
/// Conforming types are responsible for taking a validated `Mail` object and
/// transmitting it via a specific transport mechanism (e.g., SMTP, SES).
public protocol MailProtocol: Sendable {

    /// Asynchronously sends the specified email.
    /// - Parameter email: The `Mail` object to be sent. Must be pre-validated by its initializer.
    /// - Throws: `Error` if the delivery fails due to network or provider issues.
    func send(_ email: Mail) async throws(MailError)
}
