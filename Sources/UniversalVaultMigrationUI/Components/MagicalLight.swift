//
//  MagicalLight.swift
//  Box
//
//  Created by Jeremy Marchand on 27/03/2023.
//
//  Copyright (c) 2023 Dashlane Inc
//  This software is licensed under the MIT License. See the LICENSE.md file for details.

import SwiftUI

/// Magical light coming from the open box.
public struct MagicalLight: View {
    @State
    var isAnimating: Bool = false

    public init() {

    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            Image("BaseLight", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
                .opacity(isAnimating ? 1.0 : 0.7)
                .animation(Animation.linear(duration: 1.8).repeatForever(), value: isAnimating)

            Image("Light2", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(isAnimating ? 1.0 : 0.2)
                .animation(Animation.linear(duration: 1.3).repeatForever(), value: isAnimating)
                .padding(isAnimating ? 0 : 5)

            Image("Light1", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(isAnimating ? 0.3 : 1.0)
                .padding(isAnimating ? 5 : 0)

                .animation(Animation.linear(duration: 1.0).repeatForever(), value: isAnimating)
        }
        .frame(width: 300, height: 300)
        .transition(.scale(scale: 1.3, anchor: .bottom).combined(with: .opacity))
        .onAppear {
            isAnimating = true
        }
    }
}

struct MagicalLight_Previews: PreviewProvider {
    static var previews: some View {
        MagicalLight()
    }
}
