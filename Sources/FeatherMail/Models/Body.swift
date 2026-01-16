//
//  Body.swift
//  feather-mail
//
//  Created by Tibor Bödecs on 2023. 01. 16..
//

/// Represents the body content of an email message.
public enum Body: Sendable {

    /// Plain, unformatted text content.
    case plainText(String)

    /// HTML-formatted content for rich-text emails.
    case html(String)
}
