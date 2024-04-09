//
//  Component+Mail.swift
//  FeatherMail
//
//  Created by Tibor Bodecs on 20/11/2023.
//

import FeatherComponent
import Logging

public enum MailComponentID: ComponentID {

    /// default mail component identifier
    case `default`

    /// custom mail component identifier
    case custom(String)

    /// raw identifier
    public var rawId: String {
        switch self {
        case .default:
            return "mail-id"
        case .custom(let value):
            return "\(value)-mail-id"
        }
    }
}

public extension ComponentRegistry {

    /// add a new mail component using a context
    func addMail(
        _ context: ComponentContext,
        id: MailComponentID = .default
    ) async throws {
        try await add(context, id: id)
    }

    /// returns a mail component by a given id
    func mail(
        _ id: MailComponentID = .default,
        logger: Logger? = nil
    ) throws -> MailComponent {
        guard let mail = try get(id, logger: logger) as? MailComponent else {
            fatalError("Mail component not found, use `add` to register.")
        }
        return mail
    }
}
