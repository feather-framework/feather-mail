//
//  DefaultMailValidator.swift
//  feather-mail
//
//  Created by gerp83 on 2026. 01. 16..
//

/// Default, transport-agnostic validator for `Mail`.
///
/// This validator performs lightweight sanity checks that are cheap,
/// deterministic, and safe to run before attempting delivery.
///
/// Validation rules:
/// - sender address must not be empty
/// - subject must not be empty
/// - at least one valid recipient must exist
/// - basic header injection prevention
/// - optional total attachment size limit
public struct DefaultMailValidator: MailValidating, Sendable {

    /// Maximum allowed total attachment size in bytes.
    /// If `nil`, attachment size validation is skipped.
    private let maxTotalAttachmentSize: Int?

    /// Creates a new default mail validator.
    ///
    /// - Parameter maxTotalAttachmentSize: Optional maximum total size of all
    ///   attachments combined, in bytes.
    public init(maxTotalAttachmentSize: Int? = nil) {
        self.maxTotalAttachmentSize = maxTotalAttachmentSize
    }

    /// Validates the given mail instance.
    ///
    /// - Parameter mail: The `Mail` object to validate.
    /// - Throws: `MailError` if validation fails.
    public func validate(_ mail: Mail) throws(MailError) {

        try validateSender(mail)
        try validateSubject(mail)
        try validateRecipients(mail)
        try validateAttachments(mail)
        try validateSecurity(mail)
    }
}

// MARK: - Validation Rules

private extension DefaultMailValidator {

    /// Validates the sender address.
    func validateSender(_ mail: Mail) throws(MailError) {
        guard !mail.from.email.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            throw MailError.invalidSender
        }
    }

    /// Validates the subject line.
    func validateSubject(_ mail: Mail) throws(MailError) {
        guard !mail.subject.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw MailError.invalidSubject
        }
    }

    /// Ensures at least one valid recipient exists.
    func validateRecipients(_ mail: Mail) throws(MailError) {
        let recipients = mail.to + mail.cc + mail.bcc
        guard recipients.contains(where: \.isValid) else {
            throw MailError.invalidRecipient
        }
    }

    /// Validates total attachment size if a limit is configured.
    func validateAttachments(_ mail: Mail) throws(MailError) {
        guard let maxSize = maxTotalAttachmentSize else {
            return
        }

        let totalSize = mail.attachments.reduce(0) { $0 + $1.data.count }
        guard totalSize <= maxSize else {
            throw MailError.attachmentsTooLarge
        }
    }

    /// Prevents basic email header injection attacks.
    func validateSecurity(_ mail: Mail) throws(MailError) {
        let valuesToCheck = [
            mail.subject,
            mail.from.email,
        ]

        guard
            valuesToCheck.allSatisfy({
                !$0.contains("\n") && !$0.contains("\r")
            })
        else {
            throw MailError.headerInjectionDetected
        }
    }
}
