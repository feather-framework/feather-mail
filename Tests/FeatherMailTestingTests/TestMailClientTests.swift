import FeatherMail
import FeatherMailTesting
import Testing

@Suite
struct TestMailClientTests {

    @Test
    func sendsMessagesInOrderAndClearsSharedMailbox() async throws {
        let mailbox = TestMailbox()
        let client = TestMailClient(mailbox: mailbox)
        let first = makeMail(subject: "First")
        let second = makeMail(subject: "Second")

        try await client.send(first)
        try await client.send(second)

        #expect(await client.getMailbox().map(\.subject) == ["First", "Second"])
        #expect(await mailbox.getMessages().map(\.subject) == ["First", "Second"])

        await client.clearMailbox()

        #expect(await mailbox.getMessages().isEmpty)
    }

    @Test
    func validationDoesNotStoreMessage() async throws {
        let client = TestMailClient()

        try await client.validate(makeMail(subject: "Validated"))

        #expect(await client.getMailbox().isEmpty)
    }

    @Test
    func sendWrapsValidatorFailureAndDoesNotStoreMessage() async {
        let mailbox = TestMailbox(
            validator: TestMailValidator(error: .invalidSubject)
        )
        let client = TestMailClient(mailbox: mailbox)

        do {
            try await client.send(makeMail(subject: "Rejected"))
            Issue.record("Expected the mailbox validator to reject the message.")
        }
        catch MailError.validation(.invalidSubject) {
            // Expected validation failure.
        }
        catch {
            Issue.record("Unexpected mail error: \(error)")
        }

        #expect(await client.getMailbox().isEmpty)
    }

    private func makeMail(subject: String) -> Mail {
        Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: subject,
            body: .plainText("Body")
        )
    }
}
