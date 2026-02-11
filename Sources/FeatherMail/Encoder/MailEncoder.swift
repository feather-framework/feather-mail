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
    /// - Parameter mail: The mail to encode. The mail must be validated
    ///   before calling this method.
    /// - Returns: A raw MIME string suitable for transport providers.
    /// - Throws: `MailError.validation(.mailEncodeError)` when the message cannot be constructed.
    func encode(
        mail: Mail
    ) throws(MailError) -> String
}
