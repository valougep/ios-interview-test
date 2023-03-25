//
//  FriendCellModel.swift
//  FriendCellModel
//
//  Created by Antoine Baché on 07/08/2022.
//  Copyright © 2022 Ten Ten. All rights reserved.
//

import Foundation

/// **Important:** You may extend this model as you wish, but you cannot change its `.init()` methods.

@frozen
public struct FriendCellModel: Hashable {
  public let firstName: String
  public let familyName: String
  public let profilePictureURL: URL

  @inlinable
  init(
    firstName: String,
    familyName: String,
    profilePictureURL: URL
  ) {
    self.firstName = firstName
    self.familyName = familyName
    self.profilePictureURL = profilePictureURL
  }
}

extension FriendCellModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case familyName = "last_name"
        case profilePictureURL = "profilePicture"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try container.decode(String.self, forKey: .firstName)
        familyName = try container.decode(String.self, forKey: .familyName)
        profilePictureURL = try container.decode(URL.self, forKey: .profilePictureURL)
    }
}

extension FriendCellModel: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.familyName == rhs.familyName,
           lhs.firstName == rhs.firstName {
            return true
        }
        return false
    }
}

extension FriendCellModel: Comparable {
    public static func < (lhs: FriendCellModel, rhs: FriendCellModel) -> Bool {
        if lhs.familyName == rhs.familyName {
            return lhs.firstName < rhs.firstName
        } else {
            return lhs.familyName < rhs.familyName
        }
    }
}

extension FriendCellModel {
    var initials: String {
        var initials = firstName.isEmpty ? "" : "\(firstName.first!)"
        if !familyName.isEmpty {
            initials += "\(familyName.first!)"
        }
        return initials
    }
}
