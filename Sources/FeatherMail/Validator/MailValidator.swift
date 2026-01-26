//
//  MailValidator.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 01. 19..
//

/// Validation interface for `Mail` messages.
///
/// Validators enforce invariants before delivery and allow
/// different policies per transport.
public protocol MailValidator: Sendable {

    /// Validates a mail message.
    ///
    /// - Parameter mail: The `Mail` object to validate.
    /// - Throws: `MailValidationError` if validation fails.
    func validate(_ mail: Mail) async throws(MailValidationError)
}
