//
//  Component+Mail.swift
//  FeatherMail
//
//  Created by Tibor Bodecs on 20/11/2023.
//

import FeatherComponent
import Logging

/// An enumeration representing IDs for mail components.
public enum MailComponentID: ComponentID {
    /// Default mail component ID.
    case `default`
    /// Custom mail component ID with a specified string identifier.
    case custom(String)

    /// The raw identifier for the component.
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
    /// Adds a mail component to the registry.
    /// - Parameters:
    ///   - context: The component context.
    ///   - id: The ID for the mail component. Default is `.default`.
    /// - Throws: An error if the mail component cannot be added.
    func addMail(
        _ context: ComponentContext,
        id: MailComponentID = .default
    ) async throws {
        try await add(context, id: id)
    }

    /// Retrieves a mail component from the registry.
    /// - Parameters:
    ///   - id: The ID for the mail component. Default is `.default`.
    ///   - logger: An optional logger for logging messages. Default is nil.
    /// - Returns: The mail component.
    /// - Throws: An error if the mail component cannot be retrieved.
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
