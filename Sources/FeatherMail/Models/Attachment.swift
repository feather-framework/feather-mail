//
//  Attachment.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 01. 19..
//

/// File attachment included with an email message.
public struct Attachment: Sendable {

    /// File name including extension (e.g. "invoice.pdf").
    public let name: String

    /// MIME type of the attachment content (e.g. "application/pdf").
    public let contentType: String

    /// Raw attachment bytes.
    public let data: [UInt8]

    /// Creates an attachment.
    ///
    /// - Parameters:
    ///   - name: The file name.
    ///   - contentType: The MIME type of the attachment.
    ///   - data: The binary contents of the file.
    public init(
        name: String,
        contentType: String,
        data: [UInt8]
    ) {
        self.name = name
        self.contentType = contentType
        self.data = data
    }
}
