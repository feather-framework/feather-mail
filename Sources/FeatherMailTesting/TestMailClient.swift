public import FeatherMail

/// An in-memory `MailClient` that validates and records sent messages.
public struct TestMailClient: Sendable {

    private let mailbox: TestMailbox

    /// Creates a client with the supplied mailbox or a new isolated mailbox.
    public init(mailbox: TestMailbox = TestMailbox()) {
        self.mailbox = mailbox
    }
}

extension TestMailClient: MailClient {

    /// Validates and records the message as sent.
    public func send(_ mail: Mail) async throws(MailError) {
        do {
            try await mailbox.add(mail)
        }
        catch {
            throw .validation(error)
        }
    }

    /// Validates a message without recording it as sent.
    public func validate(_ mail: Mail) async throws(MailValidationError) {
        try await mailbox.validate(mail)
    }
}

extension TestMailClient {

    /// Returns sent messages in insertion order.
    public func getMailbox() async -> [Mail] {
        await mailbox.getMessages()
    }

    /// Removes all recorded messages.
    public func clearMailbox() async {
        await mailbox.clear()
    }
}
