//
//  PressReleaseButtonStyle.swift
//  PressReleaseButton
//
//  Created by Antoine Baché on 07/08/2022.
//  Copyright © 2022 Ten Ten. All rights reserved.
//

import SwiftUI

/// **TODO:** You must implement a button style that is able to execute
/// an action when the button is pressed, or released.

@frozen
public struct PressReleaseButtonStyle: PrimitiveButtonStyle {
    @usableFromInline
    let onPress: () -> Void
    @usableFromInline
    var isPressed: Binding<Bool>

  @inlinable
  public init(
    onPress: @escaping () -> Void,
    isPressed: Binding<Bool>
  ) {
      self.onPress = onPress
      self.isPressed = isPressed
  }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        isPressed.wrappedValue = true
                        configuration.trigger()
                    }
                    .onEnded { _ in
                        isPressed.wrappedValue = false
                        configuration.trigger()
                    }
            )
    }
}
