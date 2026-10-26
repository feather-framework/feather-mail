public import FeatherMail

/// An actor-isolated in-memory mailbox for tests.
public actor TestMailbox {

    private var messages: [Mail]
    private let validator: any MailValidator

    /// Creates a mailbox that validates each message before storing it.
    public init(
        messages: [Mail] = [],
        validator: any MailValidator = BasicMailValidator()
    ) {
        self.messages = messages
        self.validator = validator
    }

    /// Returns the stored messages in insertion order.
    public func getMessages() -> [Mail] {
        messages
    }

    /// Validates and stores a message.
    public func add(_ mail: Mail) async throws(MailValidationError) {
        try await validator.validate(mail)
        messages.append(mail)
    }

    /// Validates a message without storing it.
    public func validate(_ mail: Mail) async throws(MailValidationError) {
        try await validator.validate(mail)
    }

    /// Removes every stored message.
    public func clear() {
        messages.removeAll()
    }
}
