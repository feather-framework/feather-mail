//
//  MailError.swift
//  Feather-mail
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

/// Errors that can occur when initializing or sending a `Mail` object.
public enum MailError: Error {

    /// The 'from' address is missing or contains an invalid email string.
    case invalidSender

    /// The subject line is empty or consists only of whitespace.
    /// Note: Empty subjects are frequently flagged as high-risk spam by providers like Gmail and Outlook.
    case invalidSubject

    /// No valid recipients were found in the 'to', 'cc', or 'bcc' fields.
    case invalidRecipient

    /// An underlying  error occurred.
    case unknown(Error)
}
