//
//  Mail.swift
//  feather-mail
//
//  Created by Tibor Bödecs on 2023. 01. 16..
//

/// A thread-safe representation of an email message.
public struct Mail: Sendable {

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

    /// The subject line of the email.
    public let subject: String

    /// The message body content.
    public let body: Body

    /// An optional reference identifier used for threading.
    public let reference: String?

    /// Files attached to the email.
    public let attachments: [Attachment]

    /// Initializes a Mail object.
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
    ) {

        self.from = from
        self.to = to
        self.cc = cc
        self.bcc = bcc
        self.replyTo = replyTo
        self.subject = subject
        self.body = body
        self.reference = reference
        self.attachments = attachments
    }

}
