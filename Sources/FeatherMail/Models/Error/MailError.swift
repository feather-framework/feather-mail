//
//  MailError.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 01. 19..
//

/// Errors that can occur during validation or delivery.
public enum MailError: Error, Equatable {

    /// Validation failed before delivery.
    case validation(MailValidationError)

    /// A caller-provided error message.
    case custom(String)

    /// An uncategorized underlying error.
    case unknown(Error)

    /// Compares errors by their meaningful payloads.
    public static func == (lhs: MailError, rhs: MailError) -> Bool {
        switch (lhs, rhs) {
        case let (.validation(left), .validation(right)):
            return left == right
        case let (.custom(left), .custom(right)):
            return left == right
        case let (.unknown(left), .unknown(right)):
            return String(reflecting: type(of: left))
                == String(reflecting: type(of: right))
                && String(describing: left) == String(describing: right)
        default:
            return false
        }
    }

}
