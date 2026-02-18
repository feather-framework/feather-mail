//
//  Address.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 01. 19..
//

/// Email address with an optional display name.
public struct Address: Sendable {

    /// Raw email address string (e.g. "user@example.com").
    public var email: String

    /// Optional display name (e.g. "John Doe").
    public var name: String?

    /// Creates an email address.
    /// - Parameters:
    ///   - email: The email address string.
    ///   - name: Optional display name.
    public init(
        _ email: String,
        name: String? = nil
    ) {
        self.email = email
        self.name = name
    }

    /// Indicates whether the email value is non-empty.
    ///
    /// This is a lightweight sanity check and does not attempt RFC validation.
    var isValid: Bool {
        email.contains(where: { !$0.isWhitespace })
    }

    /// Returns a header-ready representation of the address.
    ///
    /// If a display name is present, the format is:
    /// `Name <email@example.com>`
    ///
    /// Otherwise, only the email address is returned.
    public var mime: String {
        if let name {
            return "\(name) <\(email)>"
        }
        return email
    }

}
