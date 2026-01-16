//
//  Attachment.swift
//  feather-mail
//
//  Created by Tibor Bödecs on 2023. 01. 16..
//

import Foundation

/// Represents a file attachment included with an email message.
public struct Attachment: Sendable {

    /// The file name, including extension (e.g. "invoice.pdf").
    public let name: String

    /// The MIME type of the attachment content (e.g. "application/pdf").
    public let contentType: String

    /// The raw binary data of the attachment.
    public let data: Data

    /// Creates a new attachment.
    ///
    /// - Parameters:
    ///   - name: The file name.
    ///   - contentType: The MIME type of the attachment.
    ///   - data: The binary content of the file.
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
