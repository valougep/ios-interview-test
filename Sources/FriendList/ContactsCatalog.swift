//
//  ContactsCatalog.swift
//  FriendList
//
//  Created by Phivos Valougeorgis on 25/03/2023.
//

import Foundation
import Combine

@MainActor
final class ContactsCatalog: ObservableObject {
    @Published private(set) var friends: [FriendCellModel] = []
    @Published var didError: Bool = false
    @Published var catalogError: CatalogError?
    @Published private var thumbnailImages: [Int: Data] = [:]
    @Published var searchQuery: String = ""

    private let url: URL
    private var subscriptions = Set<AnyCancellable>()
    private var fullList: [FriendCellModel] = []

    private var filteredList: [FriendCellModel] {
        guard !searchQuery.isEmpty else { return fullList }
        return fullList.filter { friend in
            if friend.familyName.localizedCaseInsensitiveContains(searchQuery) ||
                friend.firstName.localizedCaseInsensitiveContains(searchQuery) {
                return true
            }
            return false
        }
    }

    init(url: URL) {
        self.url = url

        $searchQuery.sink { [weak self] _ in
            guard let self else { return }
            self.friends = self.filteredList
        }
        .store(in: &subscriptions)
    }

    func updateContacts() async {
        do {
            let friendsList = try await fetchFriends(url: url)
            let uniquingFriendsList = Array(Set(friendsList))
            fullList = uniquingFriendsList.sorted()
            friends = filteredList
        } catch {
            fullList = []
            friends = []
            catchError(error)
        }
    }

    func updateThumbnail(for friend: FriendCellModel) async {
        do {
            try await fetchThumbImage(from: friend)
        } catch {
            catchError(error)
        }
    }

    func thumbnailData(for friend: FriendCellModel) -> Data? {
        thumbnailImages[friend.hashValue]
    }

    private func catchError(_ error: Error) {
        guard !Task.isCancelled else { return }
        didError = true
        guard let error = error as? CatalogError else { return }
        catalogError = error
    }

    private func fetchFriends(url: URL) async throws -> [FriendCellModel] {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                return try JSONDecoder().decode([FriendCellModel].self, from: data)
            } catch {
                if let error = error as? DecodingError {
                    throw CatalogError.decodingError(error)
                } else {
                    throw CatalogError.otherError(error)
                }
            }
        } catch {
            throw CatalogError.fetchFriendsListError(error)
        }
    }

    private func fetchThumbImage(url: URL) async throws -> Data {
        async let (data, _) = URLSession.shared.data(from: url)
        return try await data
    }

    private func fetchThumbImage(from friend: FriendCellModel) async throws {
        guard !thumbnailImages.contains(where: { $0.key == friend.hashValue }) else { return }
        async let thumbData = self.fetchThumbImage(url: friend.profilePictureURL)
        do {
            try await self.add(thumbData: thumbData, for: friend)
        } catch {
            throw CatalogError.fetchThumbImageError(error, friend)
        }
    }

    private func add(thumbData: Data, for friend: FriendCellModel) {
        thumbnailImages[friend.hashValue] = thumbData
    }
}
