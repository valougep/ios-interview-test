//
//  View+BezierCornerRadius.swift
//  TenTenSwiftUI
//
//  Created by Antoine Baché on 07/08/2022.
//  Copyright © 2022 Ten Ten. All rights reserved.
//

#if canImport(UIKit)

import SwiftUI
import UIKit

public extension View {
  /// Applies a Bezier corner radius to a view.
  ///
  /// - Parameters:
  ///   - radius: The radius of to apply to the corners
  ///   - corners: The corners to which the radius will be applied
  @inlinable
  func bezierCornerRadius(
    _ radius: CGFloat,
    corners: UIRectCorner = .allCorners
  ) -> some View {
    self.clipShape(RoundedCorner(radius: radius, corners: corners))
  }
}

public struct RoundedCorner: Shape {
    @usableFromInline
    let corners: UIRectCorner
    @usableFromInline
    let radius: CGFloat

    @inlinable
    public init(
        radius: CGFloat,
        corners: UIRectCorner
    ) {
        self.corners = corners
        self.radius = radius
    }

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#endif
