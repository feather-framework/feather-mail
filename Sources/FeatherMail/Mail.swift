//
//  Mail.swift
//  FeatherMail
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import Foundation

/// A structure representing an email message.
public struct Mail: Sendable {

    /// A structure representing an email address.
    public struct Address: Sendable {
        /// The email address.
        public let email: String
        /// The name associated with the email address (optional).
        public let name: String?

        /// Initializes an Address with an email and an optional name.
        /// - Parameters:
        ///   - email: The email address.
        ///   - name: The name associated with the email address. Default is nil.
        public init(
            _ email: String,
            name: String? = nil
        ) {
            self.email = email
            self.name = name
        }
    }

    /// A structure representing an email attachment.
    public struct Attachment: Sendable {
        /// The name of the attachment.
        public let name: String
        /// The content type of the attachment.
        public let contentType: String
        /// The data of the attachment.
        public let data: Data

        /// Initializes an Attachment with a name, content type, and data.
        /// - Parameters:
        ///   - name: The name of the attachment.
        ///   - contentType: The content type of the attachment.
        ///   - data: The data of the attachment.
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

    /// An enumeration representing the body of an email.
    public enum Body: Sendable {
        /// Plain text body.
        case plainText(String)
        /// HTML formatted body.
        case html(String)
    }

    /// The sender's address.
    public let from: Address
    /// The primary recipient addresses.
    public let to: [Address]
    /// The carbon copy recipient addresses.
    public let cc: [Address]
    /// The blind carbon copy recipient addresses.
    public let bcc: [Address]
    /// The reply-to addresses.
    public let replyTo: [Address]
    /// The subject of the email.
    public let subject: String
    /// The body of the email.
    public let body: Body
    /// The reference identifier (optional).
    public let reference: String?
    /// The email attachments.
    public let attachments: [Attachment]

    /// Initializes a Mail instance with the specified parameters.
    /// - Parameters:
    ///   - from: The sender's address.
    ///   - to: The primary recipient addresses.
    ///   - cc: The carbon copy recipient addresses. Default is an empty array.
    ///   - bcc: The blind carbon copy recipient addresses. Default is an empty array.
    ///   - replyTo: The reply-to addresses. Default is an empty array.
    ///   - subject: The subject of the email.
    ///   - body: The body of the email.
    ///   - reference: The reference identifier. Default is nil.
    ///   - attachments: The email attachments. Default is an empty array.
    /// - Throws: `MailComponentError.invalidRecipient` if there are no valid recipients in `to`, `cc`, or `bcc`.
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
    ) throws {
        guard !to.isEmpty || !cc.isEmpty || !bcc.isEmpty else {
            throw MailComponentError.invalidRecipient
        }
        self.from = from
        self.to = to
        self.cc = cc
        self.bcc = bcc
        self.subject = subject
        self.body = body
        self.replyTo = replyTo
        self.reference = reference
        self.attachments = attachments
    }
}
