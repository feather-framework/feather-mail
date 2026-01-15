//
//  FeatherMailTestSuite.swift
//  feather-mail
//
//  Created by Tibor Bödecs on 2023. 01. 16..
//

import Testing
@testable import FeatherMail

@Suite
class FeatherMailTestSuite {

    @Test
    func testNormal() async throws {

        let mail = MockMailStruct()
        let mailTestSuite = MockMailTestUtil(mail)

        try await mailTestSuite.testAll(from: "from@from.from", to: "to@to.to")
    }

    @Test
    func testFromError() async throws {

        let mail = MockMailStruct()
        let mailTestSuite = MockMailTestUtil(mail)

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

        let mail = MockMailStruct()
        let mailTestSuite = MockMailTestUtil(mail)

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

        let mail = MockMailStruct()
        let mailTestSuite = MockMailTestUtil(mail)

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
