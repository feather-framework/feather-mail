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
/// - builds standard email headers (From, To, Cc, Reply-To, Subject, Date)
/// - supports plain text and HTML bodies
/// - supports attachments using `multipart/mixed`
///
/// This type performs **no validation**. Callers are expected to validate
/// the `Mail` instance before encoding.
public struct RawMailEncoder: Sendable {

    /// Creates a raw mail encoder.
    public init() {}

    /// Encodes a mail into a raw MIME message string.
    ///
    /// - Parameters:
    ///   - mail: The mail to encode. The mail must be validated
    ///     before calling this method.
    ///   - dateHeader: RFC 2822-formatted date header value.
    ///   - messageID: Message identifier value, including angle brackets.
    /// - Returns: A raw MIME string suitable for transport providers.
    /// - Throws: `MailError.validation(.mailEncodeError)` when the message cannot be constructed.
    public func encode(
        _ mail: Mail,
        dateHeader: String,
        messageID: String
    ) throws(MailError) -> String {

        var out = String()
        out.reserveCapacity(4096)

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
        out += "Date: \(dateHeader)\r\n"
        out += "Message-ID: \(messageID)\r\n"

        if let reference = mail.reference {
            out += "In-Reply-To: \(reference)\r\n"
            out += "References: \(reference)\r\n"
        }

        let boundary = mail.attachments.isEmpty ? nil : createBoundary()

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
        }

        out += "\r\n"

        return out
    }
}

// MARK: - Helpers

private extension RawMailEncoder {

    /// Creates a unique MIME boundary without Foundation.
    func createBoundary() -> String {
        var generator = SystemRandomNumberGenerator()
        let value = UInt64.random(
            in: UInt64.min...UInt64.max,
            using: &generator
        )
        return "Boundary-\(String(value, radix: 16))"
    }
}
