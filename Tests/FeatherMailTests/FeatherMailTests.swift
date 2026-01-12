//
//  FeatherMailTests.swift
//  feather-mail
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import Testing
import FeatherMail
@testable import FeatherMailTesting

final class FeatherMailTests {

    @Test
    func testNormal() async throws {

        let mail = MailStruct()
        let mailTestSuite = MailTestSuite(mail)

        try await mailTestSuite.testAll(from: "from@from.from", to: "to@to.to")
    }

    @Test
    func testFromError() async throws {

        let mail = MailStruct()
        let mailTestSuite = MailTestSuite(mail)

        do {
            try await mailTestSuite.testAll(
                from: "",
                to: "to@to.com"
            )
        }
        catch let error {
            #expect(error == .invalidSender)
        }
    }

    @Test
    func testToError() async throws {

        let mail = MailStruct()
        let mailTestSuite = MailTestSuite(mail)

        do {
            try await mailTestSuite.testAll(
                from: "from@from.from",
                to: ""
            )
        }
        catch let error {
            #expect(error == .invalidRecipient)
        }
    }

    @Test
    func testSubjectError() async throws {

        let mail = MailStruct()
        let mailTestSuite = MailTestSuite(mail)

        do {
            try await mailTestSuite.testAll(
                from: "from@from.from",
                to: "to@to.com",
                subject: ""
            )
        }
        catch let error {
            #expect(error == .invalidSubject)
        }
    }
}
