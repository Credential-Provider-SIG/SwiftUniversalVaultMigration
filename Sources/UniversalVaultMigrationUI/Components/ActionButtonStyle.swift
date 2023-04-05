//
//  ActionButtonStyle.swift
//  
//
//  Created by Jeremy Marchand on 30/03/2023.
//
//  Copyright (c) 2023 Dashlane Inc
//  This software is licensed under the MIT License. See the LICENSE.md file for details.

import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2.bold())
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .foregroundColor(.white)
            .background(configuration.isPressed ? Color.accentColor.opacity(0.8) : Color.accentColor)
            .containerShape(Capsule())
    }
}

extension ButtonStyle where Self == ActionButtonStyle {
    static var action: ActionButtonStyle { .init() }
}

struct ActionButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Action") {

        }.buttonStyle(.action)
    }
}
