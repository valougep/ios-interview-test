//
//  PressReleaseButton.swift
//  PressReleaseButton
//
//  Created by Antoine Baché on 07/08/2022.
//  Copyright © 2022 Ten Ten. All rights reserved.
//

import SwiftUI

/// **TODO:** You should implement a `PressReleaseButton` button view that is able to perform an action
/// when it is pressed or released.
///
/// You must also implement `PressReleaseButtonStyle` (cf: `PressReleaseButtonStyle.swift`)
/// that you _may or may not_ use to implement `PressReleaseButton`.
///

@frozen
public struct PressReleaseButton<Label: View>: View {
  public typealias ActionCallback = () -> Void
    @usableFromInline
    let onPress: ActionCallback
    @usableFromInline
    let onRelease: ActionCallback
    @usableFromInline
    var isPressed: Binding<Bool>
    @usableFromInline
    @ViewBuilder let label: () -> Label

  @inlinable
  public init(
    onPress: @escaping ActionCallback,
    onRelease: @escaping ActionCallback,
    isPressed: Binding<Bool>,
    @ViewBuilder label: @escaping () -> Label
  ) {
      self.onPress = onPress
      self.onRelease = onRelease
      self.isPressed = isPressed
      self.label = label
  }

  public var body: some View {
      return Button(action: {
          isPressed.wrappedValue ? onPress() : onRelease()
      }, label: label)
          .buttonStyle(PressReleaseButtonStyle(onPress: onPress, isPressed: isPressed))
  }
}
