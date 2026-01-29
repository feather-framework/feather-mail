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
        "Boundary-\(String(UInt64.random(in: UInt64.min...UInt64.max), radix: 16))"
    }
}

//  Foundation-free Base64 encoding for byte arrays.
private extension Array where Element == UInt8 {
    /// Returns a Base64 string representation of the byte array.
    func base64EncodedString() -> String {
        guard !isEmpty else {
            return ""
        }

        let alphabet = Array(
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
                .utf8
        )
        var output: [UInt8] = []
        output.reserveCapacity(((count + 2) / 3) * 4)

        var index = 0
        while index < count {
            let byte0 = self[index]
            let byte1 = (index + 1 < count) ? self[index + 1] : 0
            let byte2 = (index + 2 < count) ? self[index + 2] : 0

            let triple =
                (UInt32(byte0) << 16) | (UInt32(byte1) << 8) | UInt32(byte2)

            output.append(alphabet[Int((triple >> 18) & 0x3F)])
            output.append(alphabet[Int((triple >> 12) & 0x3F)])

            if index + 1 < count {
                output.append(alphabet[Int((triple >> 6) & 0x3F)])
            }
            else {
                output.append(UInt8(ascii: "="))
            }

            if index + 2 < count {
                output.append(alphabet[Int(triple & 0x3F)])
            }
            else {
                output.append(UInt8(ascii: "="))
            }

            index += 3
        }

        return String(decoding: output, as: UTF8.self)
    }
}
