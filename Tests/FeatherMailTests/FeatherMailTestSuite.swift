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
    func invalidSenderThrows() throws {
        let validator = BasicMailValidator()

        let mail = Mail(
            from: .init("   "),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body")
        )

        #expect(throws: MailValidationError.invalidSender) {
            try validator.validate(mail)
        }
    }

    // MARK: - Invalid Subject

    @Test
    func invalidSubjectThrows() throws {
        let validator = BasicMailValidator()

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "   ",
            body: .plainText("Body")
        )

        #expect(throws: MailValidationError.invalidSubject) {
            try validator.validate(mail)
        }
    }

    // MARK: - Invalid Recipient

    @Test
    func invalidRecipientThrows() throws {
        let validator = BasicMailValidator()

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("   ")],
            subject: "Hello",
            body: .plainText("Body")
        )

        #expect(throws: MailValidationError.invalidRecipient) {
            try validator.validate(mail)
        }
    }

    // MARK: - Attachments Too Large

    @Test
    func attachmentsTooLargeThrows() throws {
        let validator = BasicMailValidator(maxTotalAttachmentSize: 100)

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

        #expect(throws: MailValidationError.attachmentsTooLarge) {
            try validator.validate(mail)
        }
    }

    // MARK: - Header Injection

    @Test
    func headerInjectionThrows() throws {
        let validator = BasicMailValidator()

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello\nInjected",
            body: .plainText("Body")
        )

        #expect(throws: MailValidationError.headerInjectionDetected) {
            try validator.validate(mail)
        }
    }

    @Test
    func customHeaderInjectionThrows() throws {
        let validator = BasicMailValidator()
        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body"),
            customHeaders: [
                .init(
                    name: "List-Unsubscribe",
                    value: "<https://example.com>\r\nBcc: victim@example.com"
                )
            ]
        )

        #expect(throws: MailValidationError.headerInjectionDetected) {
            try validator.validate(mail)
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
    func validMailSucceeds() throws {
        let validator = BasicMailValidator()

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body")
        )

        try validator.validate(mail)
    }
}
