//
//  DefaultBoundaryGenerator.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 02. 06..
//

public struct DefaultBoundaryGenerator: BoundaryGenerator {

    /// Creates a default MIME boundary generator.
    public init() {}

    /// Generates a unique MIME boundary without Foundation.
    public func generate() -> String {
        "Boundary-\(String(UInt64.random(in: UInt64.min...UInt64.max), radix: 16))"
    }
}
