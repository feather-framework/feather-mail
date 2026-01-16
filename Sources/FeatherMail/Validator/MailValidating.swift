//
//  MailValidating.swift
//  feather-mail
//
//  Created by gerp83 on 2026. 01. 16.
//

/// A protocol defining validation rules for `Mail` objects.
///
/// Validators are responsible for ensuring that a mail instance
/// satisfies required invariants before delivery. This separation
/// allows different validation policies for different transports.
public protocol MailValidating: Sendable {

    /// Validates the given mail instance.
    ///
    /// - Parameter mail: The `Mail` object to validate.
    /// - Throws: `MailError` if validation fails.
    func validate(_ mail: Mail) throws(MailError)
}
