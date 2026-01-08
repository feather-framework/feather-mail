//
//  FeatherMailTests.swift
//  feather-mail
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import XCTest
import FeatherMail
@testable import FeatherMailTesting

final class FeatherMailTests: XCTestCase {

    func testNormal() async throws {

        let mail = MailStruct()
        let mailTestSuite = MailTestSuite(mail)

        try await mailTestSuite.testAll(from: "from@from.from", to: "to@to.to")
    }

    func testFromError() async throws {

        let mail = MailStruct()
        let mailTestSuite = MailTestSuite(mail)

        do {
            try await mailTestSuite.testAll(
                from: "",
                to: "to@to.com"
            )
        }
        catch let error as MailTestSuiteError {
            XCTAssertTrue(error.error as? MailError != nil)
        }
    }

    func testToError() async throws {

        let mail = MailStruct()
        let mailTestSuite = MailTestSuite(mail)

        do {
            try await mailTestSuite.testAll(
                from: "from@from.from",
                to: ""
            )
        }
        catch let error as MailTestSuiteError {
            XCTAssertTrue(error.error as? MailError != nil)
        }
    }
}
