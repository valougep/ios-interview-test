//
//  SettingsScreen.swift
//  Settings
//
//  Created by Antoine Baché on 14/08/2022.
//  Copyright © 2022 Ten Ten. All rights reserved.
//

import SwiftUI
import TinyComponentsKit

/// **TODO:** You must follow the provided Figma and implement its content.
/// https://www.figma.com/file/nqXnSagl1TMbHt1f8asOz6/Settings-test?node-id=0%3A1

@frozen
public struct SettingsScreen: View {
    @usableFromInline
    let user: UserModel

    static let firstSection: [SettingsRow] = [.starred, .linkedDevices]
    static let secondSection: [SettingsRow] = [.account, .chats, .notifications, .data]
    static let thirdSection: [SettingsRow] = [.help, .tell]

    /// **Important**: This constructor must not change.
    @inlinable
    public init(
        user: UserModel
    ) {
        self.user = user
    }

    public var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 23) {
                        StatusRow(user: user)
                        VStack(spacing: 26) {
                            Section(elements: Self.firstSection)
                            Section(elements: Self.secondSection)
                            Section(elements: Self.thirdSection)
                        }
                    }
                    .padding()
                }
                .background(Text("You joined at \(formattedDate)")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.textGray)
                    .padding(.bottom), alignment: .bottom)
            }
            .navigationTitle("Settings")
            .customNavBar()
        }
    }

    private var formattedDate: String {
        user.joinedAt.formatted(.dateTime.month(.wide).day().year())
    }
}

struct Section: View {
    let elements: [SettingsRow]

    @State private var dividerWidth: CGFloat = .zero

    var body: some View {
        VStack(alignment: .leadingElementTitle, spacing: 0) {
            if let first = elements.first {
                SettingsRowView(element: first)
                ForEach(elements.dropFirst().dropLast()) { element in
                    Divider()
                        .foregroundColor(.lineGray)
                        .frame(width: dividerWidth)

                    SettingsRowView(element: element)
                }
                if let last = elements.last, last != first {
                    Divider()
                        .foregroundColor(.lineGray)
                        .frame(width: dividerWidth)
                    SettingsRowView(element: last)
                }
            }
        }
        .onPreferenceChange(CellDividerWidthPreferenceKey.self) { width in
            dividerWidth = width + 20
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct StatusRow: View {
    let user: UserModel

    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .foregroundColor(.buttonGray)
                .frame(width: 57, height: 57)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.primary)
                Text(user.status)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.textGray)
            }
            Spacer()
            Circle().foregroundColor(.buttonGray)
                .frame(width: 36, height: 36)
                .overlay(Image("QR_icon", bundle: Bundle.module))
        }
        .padding()
        .frame(height: 78)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var title: String {
        var title: String = ""
        if let firstName = user.nameComponents.givenName {
            title = firstName
        }
        if let familyName = user.nameComponents.familyName {
            title += " \(familyName)"
        }
        return title
    }
}

struct SettingsRowView: View {
    let element: SettingsRow
    var body: some View {
        NavigationLink(destination: { EmptyView() }) {
            HStack(spacing: 17) {
                thumbnail(for: element)
                HStack {
                    Text(element.title)
                        .foregroundColor(.black)
                        .font(.system(size: 17, weight: .medium))
                        .alignmentGuide(HorizontalAlignment.leadingElementTitle) { d in
                            d[.leading]
                        }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.iconGray)
                }
                .overlay(GeometryReader { proxy in
                    Color.clear.preference(key: CellDividerWidthPreferenceKey.self,
                                           value: proxy.size.width)
                })
            }
            .padding(20)
        }
        .frame(height: 50)
    }

    @ViewBuilder
    private func thumbnail(for element: SettingsRow) -> some View {
        element.imageColor
            .frame(width: 30, height: 30)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(element.image
                .resizable()
                .scaledToFit())
    }
}


struct CellDividerWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

extension HorizontalAlignment {
    struct LeadingElementTitle: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[HorizontalAlignment.leading]
        }
    }

    static let leadingElementTitle = HorizontalAlignment(LeadingElementTitle.self)
}
