//
//  Mail.swift
//  feather-mail
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import Foundation

/// A thread-safe representation of an email message.
public struct Mail: Sendable {

    /// Represents an email identity consisting of an email string and an optional display name.
    public struct Address: Sendable {
        /// The raw email address (e.g., "user@example.com").
        public let email: String
        /// An optional display name (e.g., "John Doe").
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

        /// Internal validation helper to ensure the email is not just whitespace.
        var isValid: Bool {
            !email.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }

    /// Represents a file attached to the email.
    public struct Attachment: Sendable {
        /// The filename, including extension (e.g., "invoice.pdf").
        public let name: String
        /// The MIME type of the content (e.g., "application/pdf").
        public let contentType: String
        /// The raw binary data of the file.
        public let data: Data

        /// attachment init
        public init(
            name: String,
            contentType: String,
            data: Data
        ) {
            self.name = name
            self.contentType = contentType
            self.data = data
        }
    }

    /// Defines the format of the email content.
    public enum Body: Sendable {
        /// Standard unformatted text.
        case plainText(String)
        /// HTML formatted content for rich-text emails.
        case html(String)
    }

    /// The originating sender address.
    public let from: Address
    /// The list of primary recipients.
    public let to: [Address]
    /// The list of carbon copy recipients.
    public let cc: [Address]
    /// The list of blind carbon copy recipients.
    public let bcc: [Address]
    /// The list of addresses where replies should be directed.
    public let replyTo: [Address]
    /// The summary line of the email.
    public let subject: String
    /// The actual content of the email (Text or HTML).
    public let body: Body
    /// An optional identifier used for email threading and references.
    public let reference: String?
    /// A list of files attached to the email.
    public let attachments: [Attachment]

    /// Initializes and validates a Mail object.
    ///
    /// The initializer automatically filters out empty or whitespace-only email addresses
    /// from all recipient lists (to, cc, bcc, and replyTo).
    ///
    /// - Parameters:
    ///   - from: The sender's address. Must not be empty.
    ///   - to: An array of primary recipients.
    ///   - cc: An array of carbon copy recipients. Defaults to empty.
    ///   - bcc: An array of blind carbon copy recipients. Defaults to empty.
    ///   - replyTo: An array of addresses for replies. Defaults to empty.
    ///   - subject: The email subject. Must not be empty to avoid spam filtering.
    ///   - body: The message body content.
    ///   - reference: An optional string for message headers (threading).
    ///   - attachments: An array of file attachments. Defaults to empty.
    ///
    /// - Throws: `MailError.invalidSender` if sender is empty,
    ///   `MailError.invalidSubject` if subject is empty,
    ///   or `MailError.invalidRecipient` if no recipients exist.
    public init(
        from: Address,
        to: [Address],
        cc: [Address] = [],
        bcc: [Address] = [],
        replyTo: [Address] = [],
        subject: String,
        body: Body,
        reference: String? = nil,
        attachments: [Attachment] = []
    ) throws(MailError) {

        guard !from.email.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw MailError.invalidSender
        }

        guard !subject.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw MailError.invalidSubject
        }

        self.to = to.filter(\.isValid)
        self.cc = cc.filter(\.isValid)
        self.bcc = bcc.filter(\.isValid)
        self.replyTo = replyTo.filter(\.isValid)

        guard !self.to.isEmpty || !self.cc.isEmpty || !self.bcc.isEmpty else {
            throw MailError.invalidRecipient
        }

        self.from = from
        self.subject = subject
        self.body = body
        self.reference = reference
        self.attachments = attachments
    }

}
