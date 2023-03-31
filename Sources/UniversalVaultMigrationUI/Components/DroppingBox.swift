//
//  DroppingBox.swift
//  Box
//
//  Created by Jeremy Marchand on 26/03/2023.
//

import SwiftUI

// A box that drops with animation and close or open when touching the floor.
@available(macOS 13.0, iOS 16, *)
public struct DroppingBox<OpenContent: View>: View {
    @State
    public var isSealed: Bool = true

    @State
    public var isLevitating: Bool = true

    @ViewBuilder
    public var openContent: () -> OpenContent

    public init(isSealed: Bool = true, isLevitating: Bool = true, @ViewBuilder openContent: @escaping () -> OpenContent) {
        self.isSealed = isSealed
        self.isLevitating = isLevitating
        self.openContent = openContent
    }

    public var body: some View {
        Box(isSealed: isSealed, isLevitating: isLevitating) {
            openContent()
        }
        .containerShape(Rectangle())
        .onAppear {
            isLevitating.toggle()

            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
                isSealed.toggle()
            }
        }
    }
}

@available(macOS 13.0, iOS 16, *)
struct Dropped_Previews: PreviewProvider {
    static var previews: some View {
        DroppingBox {
            EmptyView()
        }
    }
}
