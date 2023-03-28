//
//  ConnectionIndicator.swift
//  ConnectionIndicator
//
//  Created by Antoine Baché on 07/08/2022.
//  Copyright © 2022 Ten Ten. All rights reserved.
//

import SwiftUI

/// **TODO**: You must implement a 'connection indicator' view, animated, in SwiftUI.
///
/// You should implement a view that respects the states defined in `ConnectionIndicatorState`.
/// Transitions between the states should be smooth.
///
/// When connecting, the view cannot be pressed.
/// When connected, the view can be pressed.
///
/// When the view is pressed, its borders are a bit wider and a bit more transparent.
///
/// You can use Ten Ten's connection animation as a reference, or Instagram's one.
///
/// The view must have a frame of 117x113.

@frozen
public struct ConnectionIndicator: View {
    @Binding private var state: ConnectionIndicatorState
    @State private var trimAmount: CGFloat = 1
    @State private var shouldTrim: Bool = false
    
    public init(
        state: Binding<ConnectionIndicatorState>
    ) {
        self._state = state
    }
    
    private let gradient = AngularGradient(colors: [.yellow, .orange, .red, .orange], center: .center, startAngle: .degrees(0), endAngle: .degrees(360))

    public var body: some View {
        Button(action: {
            print("Round Action")
        }) {
            Color.clear
                .frame(width: 117, height: 117)
                .background(state == .connecting ? Color.black.opacity(0.5) : Color.gray)
                .clipShape(Circle()).padding(9)
                .overlay(
                    Circle()
                        .trim(from: 0 , to: shouldTrim ? 1 : 0)
                        .stroke(gradient, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .rotationEffect(.degrees(shouldTrim ? 0 : -90))
                )
        }

        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                shouldTrim.toggle()
            }
        }
    }
}
