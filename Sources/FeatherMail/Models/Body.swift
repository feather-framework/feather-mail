//
//  Body.swift
//  feather-mail
//
//  Created by Binary Birds on 2026. 01. 19..
//

/// Email body content variants.
public enum Body: Sendable {

    /// Plain text content.
    case plainText(String)

    /// HTML content for rich text messages.
    case html(String)
}
