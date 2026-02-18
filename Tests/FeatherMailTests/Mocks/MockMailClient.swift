//
//  MockMailClient.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 01. 19..
//

import FeatherMail

/// Test mail client used for validation scenarios.
///
/// This client performs validation only and never delivers mail.
public struct MockMailClient: MailClient {

    /// Validation strategy used by the mock.
    private let validator: MailValidator

    /// Creates a mock mail client.
    public init(
        validator: MailValidator = BasicMailValidator()
    ) {
        self.validator = validator
    }

    /// No-op send used for tests.
    public func send(_ mail: Mail) async throws(MailError) {
        // Intentionally no-op for tests.
    }

    /// Validates the mail using the configured validator.
    public func validate(_ mail: Mail) async throws(MailValidationError) {
        try await validator.validate(mail)
    }
}
