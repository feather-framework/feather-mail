//
//  FeatherMailTestSuite.swift
//  feather-mail
//
//  Created by Tibor Bödecs on 2023. 01. 16..
//

import Foundation
import Testing
@testable import FeatherMail

@Suite
struct FeatherMailTestSuite {

    // MARK: - Invalid sender

    @Test
    func invalidSenderThrows() async {
        let driver = MockMailStruct()

        let mail = Mail(
            from: .init("   "),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body")
        )

        await #expect(throws: MailError.invalidSender) {
            try await driver.send(mail)
        }
    }

    // MARK: - Invalid subject

    @Test
    func invalidSubjectThrows() async {
        let driver = MockMailStruct()

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "   ",
            body: .plainText("Body")
        )

        await #expect(throws: MailError.invalidSubject) {
            try await driver.send(mail)
        }
    }

    // MARK: - Invalid recipient

    @Test
    func invalidRecipientThrows() async {
        let driver = MockMailStruct()

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("   ")],
            subject: "Hello",
            body: .plainText("Body")
        )

        await #expect(throws: MailError.invalidRecipient) {
            try await driver.send(mail)
        }
    }

    // MARK: - Attachments too large

    @Test
    func attachmentsTooLargeThrows() async {
        let validator = DefaultMailValidator(
            maxTotalAttachmentSize: 100
        )
        let driver = MockMailStruct(validator: validator)

        let data = Data(repeating: 0, count: 1_024)

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

        await #expect(throws: MailError.attachmentsTooLarge) {
            try await driver.send(mail)
        }
    }

    // MARK: - Header injection

    @Test
    func headerInjectionThrows() async {
        let driver = MockMailStruct()

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello\nInjected",
            body: .plainText("Body")
        )

        await #expect(throws: MailError.headerInjectionDetected) {
            try await driver.send(mail)
        }
    }

    // MARK: - Valid mail

    @Test
    func validMailSucceeds() async throws {
        let driver = MockMailStruct()

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body")
        )

        try await driver.send(mail)
    }
}
