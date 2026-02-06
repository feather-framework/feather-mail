//
//  BoundaryGenerator.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 02. 06..
//

/// Generates MIME boundary strings without Foundation dependencies.
public protocol BoundaryGenerator: Sendable {

    /// Returns a unique MIME boundary string.
    func generate() -> String
}
