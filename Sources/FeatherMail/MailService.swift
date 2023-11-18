//
//  MailService.swift
//  FeatherMail
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import FeatherService

/// the mail service protocol
public protocol MailService: Service {

    /// send an email
    func send(_ email: Mail) async throws
}
