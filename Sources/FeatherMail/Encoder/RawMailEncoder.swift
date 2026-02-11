//
//  RawMailEncoder.swift
//  feather-mail
//
//  Created by gerp83 on 2025. 01. 16..
//

/// Encodes `Mail` values into raw MIME messages.
///
/// `RawMailEncoder` is responsible for transforming a validated `Mail`
/// instance into a raw MIME representation suitable for transport providers.
/// The encoding logic preserves the legacy behavior and output format.
///
/// The encoder:
/// - builds standard email headers (From, To, Cc, Reply-To, Subject, Date, Message-ID)
/// - supports plain text and HTML bodies
/// - supports attachments using `multipart/mixed`
///
/// This type performs **no validation**. Callers are expected to validate
/// the `Mail` instance before encoding.
public struct RawMailEncoder: MailEncoder {

    var boundaryEncodingStrategy: (@Sendable (Mail) -> String)
    var messageIDEncodingStrategy: (@Sendable (Mail) -> String)
    var headerDateEncodingStrategy: (@Sendable () -> String)

    /// Creates a raw mail encoder.
    ///
    /// - Parameters:
    ///   - boundaryEncodingStrategy: Provides the MIME boundary string used
    ///     when attachments are present.
    ///   - messageIDEncodingStrategy: Provides the Message-ID header value,
    ///     including angle brackets.
    ///   - headerDateEncodingStrategy: Provides the RFC 2822-formatted Date header
    ///     value, for example `Mon, 26 Jan 2026 12:34:56 +0000`.
    public init(
        boundaryEncodingStrategy: (@escaping @Sendable (Mail) -> String) = {
            _ in
            "Boundary-\(String(UInt64.random(in: UInt64.min...UInt64.max), radix: 16))"
        },
        messageIDEncodingStrategy: (@escaping @Sendable (Mail) -> String) = {
            mail in
            let nonce = UInt64.random(in: UInt64.min...UInt64.max)
            return "<\(nonce)\(mail.from.email.drop { $0 != "@" })>"
        },
        headerDateEncodingStrategy: (@escaping @Sendable () -> String)
    ) {
        self.boundaryEncodingStrategy = boundaryEncodingStrategy
        self.messageIDEncodingStrategy = messageIDEncodingStrategy
        self.headerDateEncodingStrategy = headerDateEncodingStrategy
    }

    /// Encodes a mail into a raw MIME message string.
    ///
    /// - Parameter mail: The mail to encode. The mail must be validated
    ///   before calling this method.
    /// - Returns: A raw MIME string suitable for transport providers.
    /// - Throws: `MailError.validation(.emptyHeaderDateString)` when the configured Date header value is empty.
    public func encode(
        mail: Mail
    ) throws(MailError) -> String {

        guard !headerDateEncodingStrategy().isEmpty else {
            throw MailError.validation(.emptyHeaderDateString)
        }

        var out = String()
        out += "From: \(mail.from.mime)\r\n"

        if !mail.to.isEmpty {
            out += "To: \(mail.to.map(\.mime).joined(separator: ", "))\r\n"
        }

        if !mail.cc.isEmpty {
            out += "Cc: \(mail.cc.map(\.mime).joined(separator: ", "))\r\n"
        }

        if !mail.replyTo.isEmpty {
            out +=
                "Reply-to: \(mail.replyTo.map(\.mime).joined(separator: ", "))\r\n"
        }

        out += "Subject: \(mail.subject)\r\n"
        out += "Date: \(headerDateEncodingStrategy())\r\n"
        out += "Message-ID: \(messageIDEncodingStrategy(mail))\r\n"

        if let reference = mail.reference {
            out += "In-Reply-To: \(reference)\r\n"
            out += "References: \(reference)\r\n"
        }

        let boundary =
            mail.attachments.isEmpty
            ? nil
            : (boundaryEncodingStrategy(mail))

        if let boundary {
            out += "Content-type: multipart/mixed; boundary=\"\(boundary)\"\r\n"
            out += "Mime-Version: 1.0\r\n\r\n"
        }

        switch mail.body {

        case .plainText(let value):
            if let boundary {
                out += "--\(boundary)\r\n"
            }
            out += "Content-Type: text/plain; charset=\"UTF-8\"\r\n"
            out += "Mime-Version: 1.0\r\n\r\n"
            out += value
            out += "\r\n\r\n"

        case .html(let value):
            if let boundary {
                out += "--\(boundary)\r\n"
            }
            out += "Content-Type: text/html; charset=\"UTF-8\"\r\n"
            out += "Mime-Version: 1.0\r\n\r\n"
            out += value
            out += "\r\n"
        }

        if let boundary {
            for attachment in mail.attachments {
                out += "--\(boundary)\r\n"
                out += "Content-type: \(attachment.contentType)\r\n"
                out += "Content-Transfer-Encoding: base64\r\n"
                out +=
                    "Content-Disposition: attachment; filename=\"\(attachment.name)\"\r\n\r\n"
                out += attachment.data.base64EncodedString()
                out += "\r\n"
            }
            out += "--\(boundary)--\r\n"
        }

        out += "\r\n"

        return out
    }

}
