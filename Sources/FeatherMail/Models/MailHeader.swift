/// A custom header added to a mail message.
public struct MailHeader: Sendable {

    /// Header field name, such as `List-Unsubscribe`.
    public let name: String

    /// Header field value.
    public let value: String

    /// Creates a custom mail header.
    ///
    /// - Parameters:
    ///   - name: Header field name.
    ///   - value: Header field value.
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
