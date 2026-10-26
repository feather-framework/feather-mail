public import FeatherMail

/// A configurable validator for deterministic mail validation tests.
public struct TestMailValidator: MailValidator {

    private let error: MailValidationError?

    /// Creates a validator that accepts messages, or always throws `error`.
    public init(error: MailValidationError? = nil) {
        self.error = error
    }

    /// Validates a message, throwing the configured error when present.
    public func validate(_ mail: Mail) async throws(MailValidationError) {
        if let error {
            throw error
        }
    }
}
