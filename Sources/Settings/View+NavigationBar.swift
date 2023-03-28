//
//  View+NavigationBar.swift
//  Settings
//
//  Created by Phivos Valougeorgis on 26/03/2023.
//

import Foundation
import SwiftUI

struct CustomNavBar: ViewModifier {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 33, weight: .heavy)]
    }

    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func customNavBar() -> some View {
        self.modifier(CustomNavBar())
    }
}
