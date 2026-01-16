//
//  MailError.swift
//  feather-mail
//
//  Created by Tibor Bödecs on 2023. 01. 16..
//

/// Errors that can occur during mail validation or delivery.
public enum MailError: Error, Equatable {

    /// The sender address is missing or invalid.
    case invalidSender

    /// The subject line is empty or invalid.
    case invalidSubject

    /// No valid recipients were found.
    case invalidRecipient

    /// The total size of attachments exceeds the allowed limit.
    case attachmentsTooLarge

    /// A potential email header injection was detected.
    case headerInjectionDetected

    // MARK: - Transport / delivery errors

    /// The mail transport rejected the message.
    case transportRejected

    /// The sender was rejected by the mail provider.
    case senderRejected

    /// Authentication with the mail server failed.
    case authenticationFailed

    /// The mail provider rate-limited the request.
    case rateLimited

    /// An unknown or unexpected error occurred.
    case unknown

}
