//
//  FeatherMailTestSuite.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 01. 19..
//

import Testing
@testable import FeatherMail

/// Validation tests for basic mail rules.
@Suite
struct FeatherMailTestSuite {

    struct SampleError: Error, CustomStringConvertible {
        let message: String
        var description: String { message }
    }

    // MARK: - Invalid Sender

    @Test
    func invalidSenderThrows() async {
        let client = MockMailClient()

        let mail = Mail(
            from: .init("   "),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body")
        )

        await #expect(throws: MailValidationError.invalidSender) {
            try await client.validate(mail)
        }
    }

    // MARK: - Invalid Subject

    @Test
    func invalidSubjectThrows() async {
        let client = MockMailClient()

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "   ",
            body: .plainText("Body")
        )

        await #expect(throws: MailValidationError.invalidSubject) {
            try await client.validate(mail)
        }
    }

    // MARK: - Invalid Recipient

    @Test
    func invalidRecipientThrows() async {
        let client = MockMailClient()

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("   ")],
            subject: "Hello",
            body: .plainText("Body")
        )

        await #expect(throws: MailValidationError.invalidRecipient) {
            try await client.validate(mail)
        }
    }

    // MARK: - Attachments Too Large

    @Test
    func attachmentsTooLargeThrows() async {
        let validator = BasicMailValidator(
            maxTotalAttachmentSize: 100
        )
        let client = MockMailClient(validator: validator)

        let data = [UInt8](repeating: 0, count: 1_024)

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body"),
            attachments: [
                .init(
                    name: "feather.png",
                    contentType: "image/png",
                    data: data
                )
            ]
        )

        await #expect(throws: MailValidationError.attachmentsTooLarge) {
            try await client.validate(mail)
        }
    }

    // MARK: - Header Injection

    @Test
    func headerInjectionThrows() async {
        let client = MockMailClient()

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello\nInjected",
            body: .plainText("Body")
        )

        await #expect(throws: MailValidationError.headerInjectionDetected) {
            try await client.validate(mail)
        }
    }

    // MARK: - Address MIME

    @Test
    func addressMimeFormatsDisplayName() {
        let named = Address("john@example.com", name: "John Doe")
        #expect(named.mime == "John Doe <john@example.com>")

        let plain = Address("john@example.com")
        #expect(plain.mime == "john@example.com")
    }

    // MARK: - Valid Mail

    @Test
    func validMailSucceeds() async throws {
        let client = MockMailClient()

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body")
        )

        try await client.validate(mail)
    }
}
