//
//  Base64Tests.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 01. 19..
//

import Testing
@testable import FeatherMail

@Suite
struct Base64Tests {

    @Test
    func emptyEncodesToEmptyString() {
        #expect([UInt8]().base64EncodedString() == "")
    }

    @Test
    func knownVectorsEncodeCorrectly() {
        #expect([0x4D, 0x61, 0x6E].base64EncodedString() == "TWFu")
        #expect([0x4D, 0x61].base64EncodedString() == "TWE=")
        #expect([0x4D].base64EncodedString() == "TQ==")
    }

    @Test
    func arrayExtensionMatchesFunction() {
        let bytes: [UInt8] = [0x66, 0x6F, 0x6F]
        #expect(bytes.base64EncodedString() == "Zm9v")
    }
}
