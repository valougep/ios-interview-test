//
//  SettingsRow.swift
//  Settings
//
//  Created by Phivos Valougeorgis on 26/03/2023.
//

import Foundation
import SwiftUI

struct SettingsRow: Identifiable {
    var id: UUID
    let image: Image
    let imageColor: Color
    let title: String

    init(image: String, imageColor: Color, title: String) {
        self.id = UUID()
        self.image = Image(image, bundle: Bundle.module)
        self.imageColor = imageColor
        self.title = title
    }

    static let starred = SettingsRow(image: "Starred_icon", imageColor: .yellow, title: "Starred Messages")
    static let linkedDevices = SettingsRow(image: "Device_icon", imageColor: .jaddedGreen, title: "Linked Devices")
    static let account = SettingsRow(image: "Account_icon", imageColor: .blue, title: "Account")
    static let chats = SettingsRow(image: "Chat_icon", imageColor: .appGreen, title: "Chats")
    static let notifications = SettingsRow(image: "Notification_icon", imageColor: .red, title: "Notifications")
    static let data = SettingsRow(image: "Data_icon", imageColor: .appGreen, title: "Storage and Data")
    static let help = SettingsRow(image: "Help_icon", imageColor: .blue, title: "Help")
    static let tell = SettingsRow(image: "Starred_icon", imageColor: .red, title: "Tell a friend")
}

extension SettingsRow: Equatable {}
