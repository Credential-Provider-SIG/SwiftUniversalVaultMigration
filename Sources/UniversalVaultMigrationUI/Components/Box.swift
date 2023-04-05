//
//  Box.swift
//  Box
//
//  Created by Jeremy Marchand on 24/03/2023.
//
//  Copyright (c) 2023 Dashlane Inc
//  This software is licensed under the MIT License. See the LICENSE.md file for details.

import SwiftUI

/// The Box
@available(macOS 13.0, iOS 16, *)
public struct Box<OpenContent: View>: View {
    let isSealed: Bool
    let isLevitating: Bool

    @State
    var showDust: Bool = false

    @ViewBuilder
    var openContent: () -> OpenContent

    public var body: some View {
        ZStack(alignment: .bottom) {
            Image("Shadow", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 3)
                .opacity(isLevitating ? 0.4 : 1)
                .scaleEffect(x: isLevitating ? 0.6 : 1, y: isLevitating ? 0.6 : 1)
                .blur(radius: isLevitating ? 22 : 0)
                .offset(y: -2)

            Group {
                if isSealed {
                    Image("Sealed", bundle: .module)
                } else {
                    Image("Open", bundle: .module)
                        .overlay {
                            ZStack {
                                if !isSealed && !isLevitating {
                                    openContent()
                                        .transition(.scale(scale: 2.90, anchor: .bottom).combined(with: .opacity))

                                }
                            }
                        }
                }
            }
            .frame(width: 256, height: 256, alignment: .bottom)
            .padding(.bottom, 23)
            .offset(y: isLevitating ? -70 : 0)
            .transition(.asymmetric(insertion: .scale(scale: 0.9, anchor: .bottom),
                                    removal: .identity))

        }
        .animation(.spring(dampingFraction: 0.4), value: isLevitating)
        .overlay(alignment: .center) {
                if showDust {
                    Dust()
                        .padding(15)
                        .offset(y: 10)
                }
        }
        .onChange(of: isLevitating, perform: { isLevitating in
            showDust = !isLevitating
        })
        .frame(width: 256, height: 300, alignment: .bottom)

        .animation(.interpolatingSpring(stiffness: 650, damping: 100), value: isSealed)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .drawingGroup()

    }
}

@available(macOS 13.0, iOS 16, *)
extension Box where OpenContent == EmptyView {
    public init(isSealed: Bool, isLevitating: Bool) {
        self.isSealed = isSealed
        self.isLevitating = isLevitating
        self.openContent = {
            EmptyView()
        }
    }
}

@available(macOS 13.0, iOS 16, *)
struct Box_Previews: PreviewProvider {
    static var previews: some View {
        Box(isSealed: false, isLevitating: false)
            .previewDisplayName("Open")
        Box(isSealed: true, isLevitating: false)
            .previewDisplayName("Sealed")

        Box(isSealed: false, isLevitating: true)
            .previewDisplayName("Open And Levitating")

        Box(isSealed: true, isLevitating: true)
            .previewDisplayName("Sealed And Levitating")

        ZStack {
            Box(isSealed: false, isLevitating: false)
                .opacity(0.5)
            Box(isSealed: true, isLevitating: false)
        }
    }
}
