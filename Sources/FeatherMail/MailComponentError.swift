//
//  MailComponentError.swift
//  FeatherMail
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

/// An error enumeration representing errors that can occur in the mail component.
public enum MailComponentError: Error {

    /// Indicates an invalid recipient error.
    case invalidRecipient

    /// Indicates an unknown error occurred.
    case unknown(Error)
}
