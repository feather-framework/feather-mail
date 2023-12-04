//
//  FeatherMailTests.swift
//  FeatherMailTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import XCTest
import FeatherService
import FeatherMail

final class FeatherMailTests: XCTestCase {

    func testSendMail() async throws {
        let registry = ServiceRegistry()
        
        try await registry.addMail(MyMailServiceContext())
        try await registry.run()

        let mail = try await registry.mail()
        XCTAssertNotNil(mail)

        let email = try Mail(
            from: .init("from@from.from"),
            to: [
                .init("to@to.to"),
            ],
            subject: "Test plain text email",
            body: .plainText("This is a plain text email.")
        )
        
        try await mail.send(email)
        
        try await registry.shutdown()
        
    }
}
