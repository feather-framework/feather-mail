//
//  Mail.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 01. 19..
//

/// Immutable email message payload.
public struct Mail: Sendable {

    /// Sender address.
    public var from: Address

    /// Primary recipients.
    public var to: [Address]

    /// Carbon copy recipients.
    public var cc: [Address]

    /// Blind carbon copy recipients.
    public var bcc: [Address]

    /// Reply-to addresses.
    public var replyTo: [Address]

    /// Subject line.
    public var subject: String

    /// Message body content.
    public var body: Body

    /// Optional reference identifier for threading.
    public var reference: String?

    /// File attachments.
    public var attachments: [Attachment]

    /// Creates a mail message.
    ///
    /// - Parameters:
    ///   - from: The sender's address.
    ///   - to: An array of primary recipients.
    ///   - cc: Carbon copy recipients. Defaults to empty.
    ///   - bcc: Blind carbon copy recipients. Defaults to empty.
    ///   - replyTo: Reply-to addresses. Defaults to empty.
    ///   - subject: Subject line.
    ///   - body: Message body content.
    ///   - reference: Optional threading reference string.
    ///   - attachments: File attachments. Defaults to empty.
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
