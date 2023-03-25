//
//  CatalogError.swift
//  FriendList
//
//  Created by Phivos Valougeorgis on 25/03/2023.
//

import Foundation

/// The error type raised on Catalog and User classes
enum CatalogError: LocalizedError {
    case decodingError(DecodingError)
    case fetchFriendsListError(Error)
    case fetchThumbImageError(Error, FriendCellModel)
    case otherError(Error)

    /// A localized message describing what error occurred.
    var errorDescription: String? {
        switch self {
        case let .decodingError(error):
            return error.localizedDescription
        case let .otherError(error):
            return error.localizedDescription
        case let .fetchFriendsListError(error):
            return error.localizedDescription
        case let .fetchThumbImageError(error, _):
            return error.localizedDescription
        }
    }

    /// A localized message describing the reason for the failure.
    var failureReason: String? {
        switch self {
        case let .decodingError(error):
            switch error {
            case let .keyNotFound(_, context):
                return context.debugDescription
            case let .dataCorrupted(context):
                return context.debugDescription
            case let .valueNotFound(_, context):
                return context.debugDescription
            case let .typeMismatch(_, context):
                return context.debugDescription
            @unknown default:
                fatalError()
            }
        default: return nil
        }
    }

    init(_ error: Error) {
        if let decodingError = error as? DecodingError {
            self = CatalogError.decodingError(decodingError)
        } else {
            self = CatalogError.otherError(error)
        }
    }
}
