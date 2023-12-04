//
//  XCTFeatherMailTests.swift
//  XCTFeatherMailTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import XCTest
import FeatherService
import FeatherMail
import XCTFeatherMail

final class XCTFeatherMailTests: XCTestCase {

    func testNormal() async throws {
        let registry = ServiceRegistry()
        
        try await registry.addMail(TestMailServiceContext(throwTestError: false))
        try await registry.run()

        let mail = try await registry.mail()
        XCTAssertNotNil(mail)

        let mailTestSuite = MailTestSuite(mail)
        
        try await mailTestSuite.testAll(from: "from@from.from", to: "to@to.to")
        
        try await registry.shutdown()
    }
    
    func testError() async throws {
        let registry = ServiceRegistry()
        
        try await registry.addMail(TestMailServiceContext(throwTestError: true))
        try await registry.run()

        let mail = try await registry.mail()
        XCTAssertNotNil(mail)

        let mailTestSuite = MailTestSuite(mail)
        
        do {
            try await mailTestSuite.testAll(from: "from@from.from", to: "to@to.to")
            XCTFail("Test is expected to fail.")
        }
        catch let error as MailTestSuiteError {
            XCTAssertTrue(error.error as? TestMailServiceError != nil)
        }
        catch {
            XCTFail("Test is expected to fail.")
        }
        
        try await registry.shutdown()
    }
}
