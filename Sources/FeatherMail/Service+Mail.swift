//
//  Service+Mail.swift
//  FeatherMail
//
//  Created by Tibor Bodecs on 20/11/2023.
//

import FeatherService
import Logging

public enum MailServiceID: ServiceID {

    /// default mail service identifier
    case `default`
    
    /// custom mail service identifier
    case custom(String)
    
    public var rawId: String {
        switch self {
        case .default:
            return "mail-id"
        case .custom(let value):
            return "\(value)-mail-id"
        }
    }
}

public extension ServiceRegistry {

    /// add a new mail service using a context
    func addMail(
        _ context: ServiceContext,
        id: MailServiceID = .default
    ) async throws {
        try await add(context, id: id)
    }

    /// returns a mail service by a given id
    func mail(
        _ id: MailServiceID = .default,
        logger: Logger? = nil
    ) throws -> MailService {
        guard let mail = try get(id, logger: logger) as? MailService else {
            fatalError("Mail service not found, use `add` to register.")
        }
        return mail
    }
}
