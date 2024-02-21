//
//  MailComponentError.swift
//  FeatherMail
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

/// mail component error
public enum MailComponentError: Error {

    case invalidRecipient

    case unknown(Error)
}
