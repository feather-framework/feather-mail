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

    private let encoder = RawMailEncoder()
    private let dateHeader = "Mon, 26 Jan 2026 12:34:56 +0000"
    private let messageID = "<12345@example.com>"

    private func makeMail(
        body: Body,
        cc: [Address] = [],
        replyTo: [Address] = [],
        reference: String? = nil,
        attachments: [FeatherMail.Attachment] = []
    ) -> Mail {
        Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            cc: cc,
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

        let raw = try encoder.encode(
            mail,
            dateHeader: dateHeader,
            messageID: messageID
        )

        #expect(raw.contains("From: from@example.com\r\n"))
        #expect(raw.contains("To: to@example.com\r\n"))
        #expect(raw.contains("Subject: Test Subject\r\n"))
        #expect(raw.contains("Date: \(dateHeader)\r\n"))
        #expect(raw.contains("Message-ID: \(messageID)\r\n"))
        #expect(raw.contains("Content-Type: text/plain; charset=\"UTF-8\"\r\n"))
        #expect(!raw.contains("multipart/mixed"))
        #expect(!raw.contains("Content-Disposition: attachment"))
    }

    @Test
    func htmlBodyUsesHtmlContentType() throws {
        let mail = makeMail(body: .html("<strong>Hi</strong>"))

        let raw = try encoder.encode(
            mail,
            dateHeader: dateHeader,
            messageID: messageID
        )

        #expect(raw.contains("Content-Type: text/html; charset=\"UTF-8\"\r\n"))
    }

    @Test
    func headersIncludeCcReplyToAndReferences() throws {
        let mail = makeMail(
            body: .plainText("Hello"),
            cc: [.init("cc@example.com")],
            replyTo: [.init("reply@example.com")],
            reference: "<ref@example.com>"
        )

        let raw = try encoder.encode(
            mail,
            dateHeader: dateHeader,
            messageID: messageID
        )

        #expect(raw.contains("Cc: cc@example.com\r\n"))
        #expect(raw.contains("Reply-to: reply@example.com\r\n"))
        #expect(raw.contains("In-Reply-To: <ref@example.com>\r\n"))
        #expect(raw.contains("References: <ref@example.com>\r\n"))
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

        let raw = try encoder.encode(
            mail,
            dateHeader: dateHeader,
            messageID: messageID
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

        let raw = try encoder.encode(
            mail,
            dateHeader: dateHeader,
            messageID: messageID
        )

        #expect(raw.contains("Content-type: multipart/mixed; boundary=\""))
        #expect(
            raw.contains(
                "Content-Disposition: attachment; filename=\"file.txt\""
            )
        )
        #expect(raw.contains("Content-Transfer-Encoding: base64"))
        #expect(raw.contains("SGVsbG8="))

        let boundaryLinePrefix = "Content-type: multipart/mixed; boundary=\""
        guard let boundaryLineStart = raw.range(of: boundaryLinePrefix) else {
            Issue.record("Missing boundary header")
            return
        }
        let afterPrefix = raw[boundaryLineStart.upperBound...]
        guard let endQuote = afterPrefix.firstIndex(of: "\"") else {
            Issue.record("Missing boundary terminator")
            return
        }
        let boundary = String(afterPrefix[..<endQuote])
        #expect(!boundary.isEmpty)
        #expect(raw.contains("--\(boundary)\r\n"))
    }
}
