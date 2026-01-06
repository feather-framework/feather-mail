//
//  MailTestSuite.swift
//  Feather-mail
//
//  Created by Tibor Bodecs on 2024. 04. 09..
//

import Foundation
import FeatherMail

/// An error type used to wrap and report failures within the `MailTestSuite`.
/// It captures the specific location (function and line) where a test failed.
public struct MailTestSuiteError: Error {

    /// The name of the function where the error occurred.
    public let function: String
    /// The line number in the source code where the error was triggered.
    public let line: Int
    /// The underlying error that caused the failure, if any.
    public let error: Error?

    /// Initializes a test suite error with source location tracking.
    /// - Parameters:
    ///   - function: The function name (defaults to the caller's function name).
    ///   - line: The line number (defaults to the caller's line number).
    ///   - error: An optional underlying error to wrap.
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

/// A thread-safe utility designed to run a battery of tests against a `MailProtocol` implementation.
public struct MailTestSuite: Sendable {

    /// The mail service instance being tested.
    let mail: MailStruct

    /// Initializes the test suite with a specific mail service.
    /// - Parameter mail: The `MailStruct` instance to use for sending emails during tests.
    public init(_ mail: MailStruct) {
        self.mail = mail
    }

    /// Executes all available mail tests (Plain Text, HTML, and Attachments) concurrently.
    /// - Parameters:
    ///   - from: The email address to be used as the sender.
    ///   - to: The email address to be used as the recipient.
    /// - Throws: A `MailTestSuiteError` if any of the sub-tests fail.
    public func testAll(
        from: String,
        to: String
    ) async throws {
        // Executes tests concurrently using async let
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
            // Wraps unknown errors into the test suite error format
            throw MailTestSuiteError(error: error)
        }
    }
}

public extension MailTestSuite {

    /// Attempts to locate the test attachment file within the module bundle.
    /// - Returns: A `URL` pointing to the 'feather.png' resource, or nil if not found.
    func getAttachmentUrl() -> URL? {
        Bundle.module.url(forResource: "feather", withExtension: "png")
    }

    // MARK: - Test Cases

    /// Validates the creation and sending of a basic plain-text email.
    /// - Parameters:
    ///   - from: Sender email address.
    ///   - to: Recipient email address.
    ///
    /// - Throws: An error if the mail cannot be sent.
    func testPlainText(
        from: String,
        to: String
    ) async throws {
        let email = try Mail(
            from: .init(from),
            to: [.init(to)],
            subject: "Test plain text email",
            body: .plainText("This is a plain text email.")
        )
        try await mail.send(email)
    }

    /// Validates the creation and sending of an HTML-formatted email.
    /// - Parameters:
    ///   - from: Sender email address.
    ///   - to: Recipient email address.
    ///   - `MailError` if the email object is invalid.
    ///   - `Error` if the mail service fails to send the message.
    /// - Throws: An error if the mail cannot be sent.
    func testHTML(
        from: String,
        to: String
    ) async throws {
        let email = try Mail(
            from: .init(from),
            to: [.init(to)],
            subject: "Test HTML email",
            body: .html("This is a <b>HTML</b> email.")
        )
        try await mail.send(email)
    }

    /// Validates the creation and sending of an email containing a file attachment.
    ///
    /// This test requires the 'feather.png' resource to be present in the bundle.
    /// If the file is missing, the test will print a warning and skip the case.
    /// - Parameters:
    ///   - from: Sender email address.
    ///   - to: Recipient email address.
    /// - Throws: An error if the mail cannot be sent.
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
            to: [.init(to)],
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
