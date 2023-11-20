//
//  MailServiceError.swift
//  FeatherMail
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

/// mail service error
public enum MailServiceError: Error {

    case invalidRecipient

    case unknown(Error)
}
