//
//  FeatherMailTests.swift
//  FeatherMailTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import XCTest
import FeatherComponent
import FeatherMail

final class FeatherMailTests: XCTestCase {

    func testSendMail() async throws {
        let registry = ComponentRegistry()

        try await registry.addMail(MyMailComponentContext())

        let mail = try await registry.mail()
        XCTAssertNotNil(mail)

        let email = try Mail(
            from: .init("from@from.from"),
            to: [
                .init("to@to.to")
            ],
            subject: "Test plain text email",
            body: .plainText("This is a plain text email.")
        )

        try await mail.send(email)
    }
}
