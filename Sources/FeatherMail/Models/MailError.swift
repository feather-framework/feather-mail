//
//  MailError.swift
//  feather-mail
//
//  Created by Tibor Bödecs on 2023. 01. 16..
//

/// Errors that can occur during mail validation or delivery.
public enum MailError: Error, Equatable {

    // MARK: - Validation errors (pre-send)
    
    /// The sender address is missing or invalid.
    case invalidSender

    /// The subject is empty or invalid.
    case invalidSubject

    /// No valid recipients were provided.
    case invalidRecipient

    /// One or more mail headers contain invalid or unsafe values.
    ///
    /// For example:
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

    /// Failed to encode the mail into the format required by the transport.
    ///
    /// This can occur when generating raw MIME data for providers like SES.
    case mailEncodeError


    // MARK: - Provider / delivery errors

    /// The mail was rejected by the provider.
    ///
    /// Common causes:
    /// - SES sandbox restrictions
    /// - Unverified identities
    /// - Provider policy violations
    case messageRejected

    /// The sender identity or domain is not verified.
    case identityNotVerified

    /// The sending quota has been exceeded.
    ///
    /// For example:
    /// - SES daily send limit reached
    case quotaExceeded

    /// The sending rate has been exceeded.
    ///
    /// For example:
    /// - SES rate limit
    /// - SMTP throttling
    case sendRateExceeded

    /// The request payload was too large.
    ///
    /// For example:
    /// - Attachments exceed provider limits
    case payloadTooLarge

    /// Access to the mail provider was denied.
    ///
    /// For example:
    /// - Invalid credentials
    /// - Missing IAM permissions
    case accessDenied

    /// The mail service is temporarily unavailable.
    ///
    /// For example:
    /// - SES sending paused
    /// - Provider outage
    case serviceUnavailable


    // MARK: - Transport / infrastructure errors

    /// A network or transport-level failure occurred.
    ///
    /// For example:
    /// - Connection timeout
    /// - DNS resolution failure
    /// - SMTP connection drop
    case transportError


    // MARK: - Fallback

    /// An unknown error occurred.
    case unknown

}
