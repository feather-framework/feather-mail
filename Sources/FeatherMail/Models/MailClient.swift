//
//  MailClient.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 01. 19..
//

/// Mail delivery interface.
public protocol MailClient: Sendable {

    /// Sends a mail message using the underlying transport.
    ///
    /// - Parameter mail: The `Mail` instance to deliver.
    /// - Throws: `MailError` when delivery fails.
    func send(_ mail: Mail) async throws(MailError)

    /// Validates a mail message without delivering it.
    ///
    /// - Parameter mail: The `Mail` instance to validate.
    /// - Throws: `MailValidationError` when validation fails.
    func validate(_ mail: Mail) async throws(MailValidationError)
}
