//
//  BasicMailValidator.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 01. 19..
//

/// Transport-agnostic validator for `Mail`.
///
/// Performs inexpensive, deterministic checks before delivery.
///
/// Validation rules:
/// - sender address must be non-empty
/// - subject must be non-empty
/// - at least one valid recipient must exist
/// - basic header injection prevention
/// - optional total attachment size limit
public struct BasicMailValidator: MailValidator, Sendable {

    /// Maximum allowed total attachment size in bytes.
    /// If `nil`, attachment size validation is skipped.
    private let maxTotalAttachmentSize: Int?

    /// Creates a mail validator.
    ///
    /// - Parameter maxTotalAttachmentSize: Optional maximum total size of all
    ///   attachments combined, in bytes.
    public init(maxTotalAttachmentSize: Int? = nil) {
        self.maxTotalAttachmentSize = maxTotalAttachmentSize
    }

    /// Validates a mail message.
    ///
    /// - Parameter mail: The `Mail` object to validate.
    /// - Throws: `MailValidationError` if validation fails.
    public func validate(_ mail: Mail) throws(MailValidationError) {

        try validateSender(mail)
        try validateSubject(mail)
        try validateRecipients(mail)
        try validateAttachments(mail)
        try validateSecurity(mail)
    }

}

// MARK: - Validation Rules

private extension BasicMailValidator {

    /// Ensures the sender address is non-empty.
    func validateSender(_ mail: Mail) throws(MailValidationError) {
        guard hasNonWhitespace(mail.from.email) else {
            throw MailValidationError.invalidSender
        }
    }

    /// Ensures the subject line is non-empty.
    func validateSubject(_ mail: Mail) throws(MailValidationError) {
        guard hasNonWhitespace(mail.subject) else {
            throw MailValidationError.invalidSubject
        }
    }

    /// Ensures at least one recipient is valid.
    func validateRecipients(_ mail: Mail) throws(MailValidationError) {
        let recipients = mail.to + mail.cc + mail.bcc
        guard recipients.contains(where: \.isValid) else {
            throw MailValidationError.invalidRecipient
        }
    }

    /// Validates total attachment size if a limit is configured.
    func validateAttachments(_ mail: Mail) throws(MailValidationError) {
        guard let maxSize = maxTotalAttachmentSize else {
            return
        }

        let totalSize = mail.attachments.reduce(0) { $0 + $1.data.count }
        guard totalSize <= maxSize else {
            throw MailValidationError.attachmentsTooLarge
        }
    }

    /// Prevents basic email header injection attacks.
    func validateSecurity(_ mail: Mail) throws(MailValidationError) {
        let valuesToCheck = [
            mail.subject,
            mail.from.email,
        ]

        guard
            valuesToCheck.allSatisfy({
                !$0.contains("\n") && !$0.contains("\r")
            })
        else {
            throw MailValidationError.headerInjectionDetected
        }
    }

    func hasNonWhitespace(_ value: String) -> Bool {
        value.contains(where: { !$0.isWhitespace })
    }
}
