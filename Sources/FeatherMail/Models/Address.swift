//
//  Address.swift
//  feather-mail
//
//  Created by Tibor Bödecs on 2023. 01. 16..
//

/// Represents an email identity consisting of an email string and an optional display name.
public struct Address: Sendable {
    
    /// The raw email address string (e.g. "user@example.com").
    public let email: String

    /// An optional human-readable display name (e.g. "John Doe").
    public let name: String?

    /// Creates a new email address.
    /// - Parameters:
    ///   - email: The email address string.
    ///   - name: An optional display name.
    public init(
        _ email: String,
        name: String? = nil
    ) {
        self.email = email
        self.name = name
    }
    
    /// Indicates whether the address contains a non-empty email value.
    ///
    /// This is a lightweight sanity check and does not perform full
    /// RFC-compliant email validation.
    var isValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty
    }

    /// Returns a MIME-compatible string representation of the address.
    ///
    /// If a display name is present, the format will be:
    /// `Name <email@example.com>`
    ///
    /// Otherwise, only the email address is returned.
    ///
    /// This representation is suitable for use in email headers.
    public var mime: String {
        if let name {
            return "\(name) <\(email)>"
        }
        return email
    }
    
}
