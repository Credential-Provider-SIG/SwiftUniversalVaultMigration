//
//  InfoBox.swift
//  Box
//
//  Created by Jeremy Marchand on 27/03/2023.
//
//  Copyright (c) 2023 Dashlane Inc
//  This software is licensed under the MIT License. See the LICENSE.md file for details.

import SwiftUI

struct InfoArea: View {
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 10) {
            Text(title).font(.largeTitle.bold())
            Text(message).font(.body.bold())
        }
        .padding()
        .multilineTextAlignment(.center)
    }
}

struct InfoBox_Previews: PreviewProvider {
    static var previews: some View {
        InfoArea(title: "Ready to Move In?",
                 message: "Drag and drop the empty box to your previous password manager")
    }
}
