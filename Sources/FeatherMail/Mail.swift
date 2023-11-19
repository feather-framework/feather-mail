//
//  Mail.swift
//  FeatherMail
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import Foundation

public struct Mail {

    public struct Address {
        public let email: String
        public let name: String?

        public init(
            _ email: String,
            name: String? = nil
        ) {
            self.email = email
            self.name = name
        }
    }

    public struct Attachment {
        public let name: String
        public let contentType: String
        public let data: Data

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

    public let from: Address
    public let to: [Address]
    public let cc: [Address]
    public let bcc: [Address]
    public let subject: String
    public let body: String
    public let isHtml: Bool
    public let replyTo: [Address]
    public let reference: String?
    public let attachments: [Attachment]

    public init(
        from: Address,
        to: [Address],
        cc: [Address] = [],
        bcc: [Address] = [],
        subject: String,
        body: String,
        isHtml: Bool = false,
        replyTo: [Address] = [],
        reference: String? = nil,
        attachments: [Attachment] = []
    ) throws {
        guard !to.isEmpty || !cc.isEmpty || !bcc.isEmpty else {
            throw MailerServiceError.invalidRecipient
        }
        self.from = from
        self.to = to
        self.cc = cc
        self.bcc = bcc
        self.subject = subject
        self.body = body
        self.isHtml = isHtml
        self.replyTo = replyTo
        self.reference = reference
        self.attachments = attachments
    }

}
