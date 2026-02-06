//
//  MailEncoder.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 02. 06.
//

/// Encodes `Mail` values into raw MIME messages suitable for transport providers.
public protocol MailEncoder: Sendable {

    /// Encodes a mail into a raw MIME message string.
    ///
    /// - Parameters:
    ///   - mail: The mail to encode. The mail must be validated
    ///     before calling this method.
    ///   - dateHeader: RFC 2822-formatted date header value.
    ///   - messageID: Message identifier value, including angle brackets.
    ///   - boundary: Optional custom MIME boundary. If `nil`, the encoder
    ///     generates one when attachments are present. Provide a valid
    ///     MIME boundary string without surrounding quotes.
    /// - Returns: A raw MIME string suitable for transport providers.
    /// - Throws: `MailError.validation(.mailEncodeError)` when the message cannot be constructed.
    func encode(
        mail: Mail,
        dateHeader: String,
        messageID: String,
        boundary: String?
    ) throws(MailError) -> String
}

public extension MailEncoder {

    /// Encodes a mail into a raw MIME message string.
    ///
    /// - Parameters:
    ///   - mail: The mail to encode. The mail must be validated
    ///     before calling this method.
    ///   - dateHeader: RFC 2822-formatted date header value.
    ///   - messageID: Message identifier value, including angle brackets.
    /// - Returns: A raw MIME string suitable for transport providers.
    /// - Throws: `MailError.validation(.mailEncodeError)` when the message cannot be constructed.
    func encode(
        mail: Mail,
        dateHeader: String,
        messageID: String
    ) throws(MailError) -> String {
        try encode(
            mail: mail,
            dateHeader: dateHeader,
            messageID: messageID,
            boundary: nil
        )
    }
}
