//
//  MailHeaderProvider.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 02. 06..
//

/// Provides RFC 2822-compatible mail header values.
public protocol MailHeaderProvider: Sendable {

    /// Returns an RFC 2822-formatted date header value.
    func dateHeader() -> String

    /// Returns a Message-ID header value, including angle brackets.
    func messageID(for mail: Mail) -> String
}

/// Default header provider that uses a caller-supplied date header.
public struct DefaultMailHeaderProvider: MailHeaderProvider {

    private let dateHeaderValue: String

    /// Creates a header provider with a preformatted date header value.
    public init(dateHeader: String) {
        self.dateHeaderValue = dateHeader
    }

    public func dateHeader() -> String {
        dateHeaderValue
    }

    public func messageID(for mail: Mail) -> String {
        let nonce = UInt64.random(in: UInt64.min...UInt64.max)
        return "<\(nonce)\(mail.from.email.drop { $0 != "@" })>"
    }
}
