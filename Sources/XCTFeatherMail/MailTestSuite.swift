//
//  MailTestSuite.swift
//  XCTFeatherMail
//
//  Created by Tibor Bodecs on 17/11/2023.
//

import Foundation
import FeatherMail

/// mail test suit error
public struct MailTestSuiteError: Error {

    /// function
    public let function: String
    /// line
    public let line: Int
    /// error
    public let error: Error?

    init(
        function: String = #function,
        line: Int = #line,
        error: Error? = nil
    ) {
        self.function = function
        self.line = line
        self.error = error
    }
}

/// mail test suite
public struct MailTestSuite {

    let mail: MailComponent

    /// mail test suite init
    public init(_ mail: MailComponent) {
        self.mail = mail
    }

    /// test all mail sending
    public func testAll(
        from: String,
        to: String
    ) async throws {
        async let tests: [Void] = [
            testPlainText(from: from, to: to),
            testHTML(from: from, to: to),
            testAttachment(from: from, to: to),
        ]
        do {
            _ = try await tests
        }
        catch let error as MailTestSuiteError {
            throw error
        }
        catch {
            throw MailTestSuiteError(error: error)
        }
    }
}

public extension MailTestSuite {

    func getAttachmentUrl() -> URL? {
        Bundle.module.url(forResource: "feather", withExtension: "png")
    }

    // MARK: - tests

    func testPlainText(
        from: String,
        to: String
    ) async throws {
        let email = try Mail(
            from: .init(from),
            to: [
                .init(to)
            ],
            subject: "Test plain text email",
            body: .plainText("This is a plain text email.")
        )
        try await mail.send(email)
    }

    func testHTML(
        from: String,
        to: String
    ) async throws {
        let email = try Mail(
            from: .init(from),
            to: [
                .init(to)
            ],
            subject: "Test HTML email",
            body: .html("This is a <b>HTML</b> email.")
        )
        try await mail.send(email)
    }

    func testAttachment(
        from: String,
        to: String
    ) async throws {

        guard
            let url = getAttachmentUrl(),
            let data = try? Data(contentsOf: url)
        else {
            print("Attachment not found, skipping test case...")
            return
        }

        let email = try Mail(
            from: .init(from),
            to: [
                .init(to)
            ],
            subject: "Test email attachment",
            body: .plainText("This is a test email with an attachment."),
            attachments: [
                .init(
                    name: "feather.png",
                    contentType: "image/png",
                    data: data
                )
            ]
        )
        try await mail.send(email)
    }
}
