//
//  FriendListScreen.swift
//  FriendListScreen
//
//  Created by Antoine Baché on 07/08/2022.
//  Copyright © 2022 Ten Ten. All rights reserved.
//

import SwiftUI
import TinyComponentsKit

/// **TODO:** You must implement a friendlist view.
/// There is a set of mocked data in `Resources/`.
/// You must load and parse the JSON to generate an array of `FriencCellModel`
/// that you'll display.
///
/// In order to implement the cells, you should follow the `cell-reference.png` and `cell-reference-no-picture.png`.
///
/// A few requirements:
/// - no scroll indicators
/// - a vertical spacing of `24` between two cells.
/// - a button that shrinks when it is pressed (a bouncy/springy animation would be appreciated).
/// - must be searchable
/// - must not lag / ram (beware, the mocked data set is huge)
/// - must be ordered, like in the iOS Contact app
/// - must work on iOS 15
///
/// You are free to extend `TinyComponentsKit` to add components you'll need.
///

public struct FriendListScreen: View {
    @StateObject var contacts: ContactsCatalog

    public init(url: URL) {
        _contacts = StateObject(wrappedValue: ContactsCatalog(url: url))
    }

    public var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(contacts.friends, id: \.hashValue) { friend in
                        VStack {
                            HStack {
                                thumbView(for: friend)
                                    .frame(width: 50, height: 40)
                                    .background(.regularMaterial)
                                    .clipShape(Circle())
                                    .task {
                                        await contacts.updateThumbnail(for: friend)
                                    }
                                contactInfoView(for: friend)
                                Spacer()
                                clickButton
                            }
                            Rectangle()
                                .frame(height: 24)
                                .foregroundColor(.clear)
                        }
                    }
                }
            }
            .padding()
            .task {
                await contacts.updateContacts()
            }
            .searchable(text: $contacts.searchQuery.animation())
            .alert("Error",
                   isPresented: $contacts.didError,
                   presenting: contacts.catalogError,
                   actions: { error in
                Button("Ok") {}
                Button("Retry") {
                    Task {
                        if case let CatalogError.fetchThumbImageError(_, friend) = error {
                            await contacts.updateThumbnail(for: friend)
                        } else {
                            await contacts.updateContacts()
                        }
                    }
                }
            }, message: { error in
                Text(error.localizedDescription)
            })
            .navigationTitle("Contacts")
        }
    }

    @ViewBuilder
    private func thumbView(for friend: FriendCellModel) -> some View {
        if let data = contacts.thumbnailData(for: friend),
           let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else {
            placeholder(for: friend)
        }
    }

    @ViewBuilder
    private func contactInfoView(for friend: FriendCellModel) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(friend.firstName)
                Text(friend.familyName)
            }
            .foregroundColor(.primary)
            .font(.headline)
            Text("Say hi!")
                .foregroundColor(.secondary)
                .font(.callout)
        }
    }

    @ViewBuilder
    private var clickButton: some View {
        Button(action: {
            //print("tap button")
        }, label: {
            Text("Click Me")
                .foregroundColor(.white)
                .font(.system(size: 13, weight: .bold))
        })
        .buttonStyle(ClickMeButtonStyle())
    }

    @ViewBuilder
    private func placeholder(for friend: FriendCellModel) -> some View {
        Text(friend.initials)
            .font(.title2)
            .foregroundColor(.secondary)
    }
}

struct ClickMeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding([.leading, .trailing], 17)
            .padding([.top, .bottom], 8)
            .background(.blue, in: Capsule())
            .opacity(configuration.isPressed ? 0.5 : 1)
            .scaleEffect(configuration.isPressed ? 0.90 : 1.00)
    }
}

public extension FriendListScreen {
    static func mocked() -> some View {
        guard let url = Bundle.module.url(forResource: "friendlist-mock", withExtension: "json") else {
            preconditionFailure()
        }
        return FriendListScreen(url: url)

    }
}
