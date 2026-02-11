//
//  MailValidationError.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 01. 19..
//

/// Errors that can occur during mail validation.
public enum MailValidationError: Error, Equatable {

    /// The sender address is missing or invalid.
    case invalidSender

    /// The subject line is empty or invalid.
    case invalidSubject

    /// No valid recipients were provided.
    case invalidRecipient

    /// One or more headers contain invalid or unsafe values.
    ///
    /// Examples include:
    /// - CRLF injection attempts
    /// - Newlines in subject or address fields
    case headerInjectionDetected

    // MARK: - Attachment errors

    /// One or more attachments exceed the allowed size.
    ///
    /// This may be detected:
    /// - During validation
    /// - By the provider (SES / SMTP)
    case attachmentsTooLarge

    // MARK: - Encoding errors

    /// The required Date header value is empty.
    case emptyHeaderDateString

    /// Failed to encode the mail into the required transport format.
    ///
    /// This can occur when generating raw MIME data for providers like SES.
    case mailEncodeError

    /// An unknown validation error occurred.
    case unknown

}
