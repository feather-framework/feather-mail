//
//  MailError.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 01. 19..
//

/// Errors that can occur during validation or delivery.
public enum MailError: Error {

    /// Validation failed before delivery.
    case validation(MailValidationError)

    /// A caller-provided error message.
    case custom(String)

    /// An uncategorized underlying error.
    case unknown(Error)

}
