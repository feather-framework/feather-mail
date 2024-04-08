//
//  XCTFeatherMailTests.swift
//  XCTFeatherMailTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import XCTest
import FeatherComponent
import FeatherMail
import XCTFeatherMail

final class XCTFeatherMailTests: XCTestCase {

    func testNormal() async throws {
        let registry = ComponentRegistry()

        try await registry.addMail(
            TestMailComponentContext(throwTestError: false)
        )

        let mail = try await registry.mail()
        XCTAssertNotNil(mail)

        let mailTestSuite = MailTestSuite(mail)

        try await mailTestSuite.testAll(from: "from@from.from", to: "to@to.to")
    }

    func testError() async throws {
        let registry = ComponentRegistry()

        try await registry.addMail(
            TestMailComponentContext(throwTestError: true)
        )

        let mail = try await registry.mail()
        XCTAssertNotNil(mail)

        let mailTestSuite = MailTestSuite(mail)

        do {
            try await mailTestSuite.testAll(
                from: "from@from.from",
                to: "to@to.to"
            )
            XCTFail("Test is expected to fail.")
        }
        catch let error as MailTestSuiteError {
            XCTAssertTrue(error.error as? TestMailComponentError != nil)
        }
        catch {
            XCTFail("Test is expected to fail.")
        }
    }
}
