//
//  RawMailEncoderTests.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 01. 26..
//

import Foundation
import Testing
@testable import FeatherMail

@Suite
struct RawMailEncoderTests {

    private func expectedDateHeader() -> String {
        "Mon, 26 Jan 2026 12:34:56 +0000"
    }

    private func expectedMessageID() -> String {
        "<12345@example.com>"
    }

    private func makeEncoder(
        boundary: String? = nil,
        messageID: String? = nil
    ) -> RawMailEncoder {
        let dateHeader = expectedDateHeader()
        let messageID = messageID ?? expectedMessageID()
        return RawMailEncoder(
            boundaryEncodingStrategy: { _ in
                boundary ?? "Boundary-Test"
            },
            messageIDEncodingStrategy: { _ in
                messageID
            },
            headerDateString: dateHeader
        )
    }

    private func makeMail(
        body: Body,
        cc: [Address] = [],
        bcc: [Address] = [],
        replyTo: [Address] = [],
        reference: String? = nil,
        attachments: [FeatherMail.Attachment] = []
    ) -> Mail {
        Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            cc: cc,
            bcc: bcc,
            replyTo: replyTo,
            subject: "Test Subject",
            body: body,
            reference: reference,
            attachments: attachments
        )
    }

    @Test
    func plainTextWithoutAttachmentsDoesNotUseMultipart() throws {
        let mail = makeMail(body: .plainText("Hello"))
        let encoder = makeEncoder()

        let raw = try encoder.encode(
            mail: mail,
        )

        #expect(raw.contains("From: from@example.com\r\n"))
        #expect(raw.contains("To: to@example.com\r\n"))
        #expect(raw.contains("Subject: Test Subject\r\n"))
        #expect(raw.contains("Date: \(expectedDateHeader())\r\n"))
        #expect(raw.contains("Message-ID: \(expectedMessageID())\r\n"))
        #expect(raw.contains("Content-Type: text/plain; charset=\"UTF-8\"\r\n"))
        #expect(!raw.contains("multipart/mixed"))
        #expect(!raw.contains("Content-Disposition: attachment"))
    }

    @Test
    func htmlBodyUsesHtmlContentType() throws {
        let mail = makeMail(body: .html("<strong>Hi</strong>"))
        let encoder = makeEncoder()

        let raw = try encoder.encode(
            mail: mail,
        )

        #expect(raw.contains("Content-Type: text/html; charset=\"UTF-8\"\r\n"))
        #expect(!raw.contains("multipart/mixed"))
    }

    @Test
    func headersIncludeCcReplyToAndReferences() throws {
        let mail = makeMail(
            body: .plainText("Hello"),
            cc: [.init("cc@example.com")],
            replyTo: [.init("reply@example.com")],
            reference: "<ref@example.com>"
        )
        let encoder = makeEncoder()

        let raw = try encoder.encode(
            mail: mail,
        )

        #expect(raw.contains("Cc: cc@example.com\r\n"))
        #expect(raw.contains("Reply-to: reply@example.com\r\n"))
        #expect(raw.contains("In-Reply-To: <ref@example.com>\r\n"))
        #expect(raw.contains("References: <ref@example.com>\r\n"))
    }

    @Test
    func bccIsNotWrittenToHeaders() throws {
        let mail = makeMail(
            body: .plainText("Hello"),
            bcc: [.init("hidden@example.com")]
        )
        let encoder = makeEncoder()

        let raw = try encoder.encode(
            mail: mail,
        )

        #expect(!raw.contains("Bcc:"))
        #expect(!raw.contains("hidden@example.com"))
    }

    @Test
    func htmlWithAttachmentUsesMultipartAndHtmlBody() throws {
        let attachment = FeatherMail.Attachment(
            name: "image.png",
            contentType: "image/png",
            data: [0x01, 0x02, 0x03]
        )
        let mail = makeMail(
            body: .html("<em>Hi</em>"),
            attachments: [attachment]
        )
        let encoder = makeEncoder()

        let raw = try encoder.encode(
            mail: mail,
        )

        #expect(raw.contains("Content-type: multipart/mixed; boundary=\""))
        #expect(raw.contains("Content-Type: text/html; charset=\"UTF-8\"\r\n"))
        #expect(
            raw.contains(
                "Content-Disposition: attachment; filename=\"image.png\""
            )
        )
    }

    @Test
    func attachmentsUseMultipartWithBoundary() throws {
        let attachment = FeatherMail.Attachment(
            name: "file.txt",
            contentType: "text/plain",
            data: Array("Hello".utf8)
        )
        let mail = makeMail(
            body: .plainText("Body"),
            attachments: [attachment]
        )
        let encoder = makeEncoder()

        let raw = try encoder.encode(
            mail: mail,
        )

        #expect(raw.contains("Content-type: multipart/mixed; boundary=\""))
        #expect(
            raw.contains(
                "Content-Disposition: attachment; filename=\"file.txt\""
            )
        )
        #expect(raw.contains("Content-Transfer-Encoding: base64"))
        #expect(raw.contains("SGVsbG8="))
        #expect(raw.contains("Mime-Version: 1.0\r\n\r\n"))

        let boundaryLinePrefix = "Content-type: multipart/mixed; boundary=\""
        guard
            let boundaryLine = raw.split(separator: "\r\n")
                .first(where: {
                    $0.hasPrefix(boundaryLinePrefix)
                })
        else {
            Issue.record("Missing boundary header")
            return
        }
        let boundarySuffix = boundaryLine.dropFirst(boundaryLinePrefix.count)
        guard boundarySuffix.last == "\"" else {
            Issue.record("Missing boundary terminator")
            return
        }
        let boundary = String(boundarySuffix.dropLast())
        #expect(!boundary.isEmpty)
        #expect(raw.contains("--\(boundary)\r\n"))
        #expect(raw.contains("--\(boundary)--\r\n"))
    }

    @Test
    func customBoundaryIsUsedWhenProvided() throws {
        let attachment = FeatherMail.Attachment(
            name: "file.txt",
            contentType: "text/plain",
            data: Array("Hello".utf8)
        )
        let mail = makeMail(
            body: .plainText("Body"),
            attachments: [attachment]
        )
        let customBoundary = "Custom-12345"
        let encoder = makeEncoder(boundary: customBoundary)

        let raw = try encoder.encode(
            mail: mail,
        )

        #expect(
            raw.contains(
                "Content-type: multipart/mixed; boundary=\"\(customBoundary)\""
            )
        )
        #expect(raw.contains("--\(customBoundary)\r\n"))
        #expect(raw.contains("--\(customBoundary)--\r\n"))
    }

    @Test
    func customMessageIDIsUsedWhenProvided() throws {
        let mail = makeMail(body: .plainText("Hello"))
        let customMessageID = "<custom-999@example.com>"
        let encoder = makeEncoder(messageID: customMessageID)

        let raw = try encoder.encode(
            mail: mail,
        )

        #expect(raw.contains("Message-ID: \(customMessageID)\r\n"))
    }

    @Test
    func makeEncoderHonorsCustomBoundaryAndMessageID() throws {
        let attachment = FeatherMail.Attachment(
            name: "file.txt",
            contentType: "text/plain",
            data: Array("Hello".utf8)
        )
        let mail = makeMail(
            body: .plainText("Body"),
            attachments: [attachment]
        )
        let customBoundary = "Boundary-From-MakeEncoder"
        let customMessageID = "<make-encoder@example.com>"
        let encoder = makeEncoder(
            boundary: customBoundary,
            messageID: customMessageID
        )

        let raw = try encoder.encode(
            mail: mail,
        )

        #expect(
            raw.contains(
                "Content-type: multipart/mixed; boundary=\"\(customBoundary)\""
            )
        )
        #expect(raw.contains("--\(customBoundary)\r\n"))
        #expect(raw.contains("Message-ID: \(customMessageID)\r\n"))
    }

    @Test
    func boundaryStrategyIsNotInvokedWithoutAttachments() throws {
        let encoder = RawMailEncoder(
            boundaryEncodingStrategy: { _ in
                Issue.record("Boundary strategy should not be invoked.")
                return "Boundary-Strategy"
            },
            messageIDEncodingStrategy: { _ in
                expectedMessageID()
            },
            headerDateString: expectedDateHeader()
        )
        let mail = makeMail(body: .plainText("Hello"))

        let raw = try encoder.encode(
            mail: mail,
        )

        #expect(!raw.contains("Content-type: multipart/mixed"))
    }

    @Test
    func boundaryStrategyIsInvokedWithAttachments() throws {
        let encoder = RawMailEncoder(
            boundaryEncodingStrategy: { _ in
                return "Boundary-Strategy"
            },
            messageIDEncodingStrategy: { _ in
                expectedMessageID()
            },
            headerDateString: expectedDateHeader()
        )
        let attachment = FeatherMail.Attachment(
            name: "file.txt",
            contentType: "text/plain",
            data: Array("Hello".utf8)
        )
        let mail = makeMail(
            body: .plainText("Body"),
            attachments: [attachment]
        )

        let raw = try encoder.encode(
            mail: mail,
        )

        #expect(
            raw.contains(
                "Content-type: multipart/mixed; boundary=\"Boundary-Strategy\""
            )
        )
    }

    @Test
    func messageIDStrategyReceivesMail() throws {
        let customMessageID = "<seen-from@example.com>"
        let encoder = RawMailEncoder(
            boundaryEncodingStrategy: { _ in
                "Boundary-Strategy"
            },
            messageIDEncodingStrategy: { mail in
                "<seen-\(mail.from.email)>"
            },
            headerDateString: expectedDateHeader()
        )
        let mail = makeMail(body: .plainText("Hello"))

        let raw = try encoder.encode(
            mail: mail,
        )

        #expect(raw.contains("Message-ID: \(customMessageID)\r\n"))
    }

    @Test
    func multipartBodyIncludesPlainTextPartBeforeAttachments() throws {
        let attachment = FeatherMail.Attachment(
            name: "file.txt",
            contentType: "text/plain",
            data: Array("Hello".utf8)
        )
        let mail = makeMail(
            body: .plainText("Body"),
            attachments: [attachment]
        )
        let encoder = makeEncoder()

        let raw = try encoder.encode(
            mail: mail,
        )

        let bodyIndex = raw.range(
            of: "Content-Type: text/plain; charset=\"UTF-8\"\r\n"
        )?
        .lowerBound
        let attachmentIndex = raw.range(
            of: "Content-Disposition: attachment; filename=\"file.txt\""
        )?
        .lowerBound
        #expect(bodyIndex != nil)
        #expect(attachmentIndex != nil)
        if let bodyIndex, let attachmentIndex {
            #expect(bodyIndex < attachmentIndex)
        }
    }

    @Test
    func htmlWithoutAttachmentsDoesNotEmitBoundaryMarkers() throws {
        let mail = makeMail(body: .html("<em>Hello</em>"))
        let encoder = makeEncoder()

        let raw = try encoder.encode(
            mail: mail,
        )

        #expect(!raw.contains("--Boundary-Test"))
        #expect(!raw.contains("Content-type: multipart/mixed"))
    }

    @Test
    func emptyHeaderDateStringThrowsValidationError() {
        let encoder = RawMailEncoder(
            boundaryEncodingStrategy: { _ in
                "Boundary-Strategy"
            },
            messageIDEncodingStrategy: { _ in
                "<message-id@example.com>"
            },
            headerDateString: ""
        )
        let mail = makeMail(body: .plainText("Hello"))

        do {
            _ = try encoder.encode(mail: mail)
            Issue.record("Expected an emptyHeaderDateString validation error.")
        }
        catch MailError.validation(let error) {
            #expect(error == .emptyHeaderDateString)
        }
        catch {
            Issue.record("Unexpected error type.")
        }
    }
}
