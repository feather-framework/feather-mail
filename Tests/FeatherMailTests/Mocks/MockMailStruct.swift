//
//  MockMailStruct.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 01. 06..
//

import FeatherMail

/// A mock mail driver used for validation testing.
///
/// This driver does not deliver mail, it only validates it using
/// `DefaultMailValidator`.
public struct MockMailStruct: MailProtocol, Sendable {

    /// the validator
    private let validator: MailValidating

    /// Initializes a MockMailStruct object.
    public init(
        validator: MailValidating = DefaultMailValidator()
    ) {
        self.validator = validator
    }

    /// Validates the mail and performs no delivery.
    public func send(_ email: Mail) async throws(MailError) {
        try validator.validate(email)
    }
}
