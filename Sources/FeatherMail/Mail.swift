//
//  Mail.swift
//  FeatherMail
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import Foundation

/// mail object
public struct Mail: Sendable {

    /// address
    public struct Address: Sendable {
        /// email
        public let email: String
        /// name
        public let name: String?

        /// mail object init
        public init(
            _ email: String,
            name: String? = nil
        ) {
            self.email = email
            self.name = name
        }
    }

    /// attachment
    public struct Attachment: Sendable {
        /// name
        public let name: String
        /// content type
        public let contentType: String
        /// data
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

    public enum Body: Sendable {
        case plainText(String)
        case html(String)
    }

    /// from
    public let from: Address
    /// to
    public let to: [Address]
    /// cc
    public let cc: [Address]
    /// bcc
    public let bcc: [Address]
    /// reply to
    public let replyTo: [Address]
    /// subject
    public let subject: String
    ///body
    public let body: Body
    /// reference
    public let reference: String?
    /// attachments
    public let attachments: [Attachment]

    /// mail attachment init
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
