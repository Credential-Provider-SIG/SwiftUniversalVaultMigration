//
//  OpenBox.swift
//  Box
//
//  Created by Jeremy Marchand on 24/03/2023.
//
//  Copyright (c) 2023 Dashlane Inc
//  This software is licensed under the MIT License. See the LICENSE.md file for details.

import SwiftUI

/// Content when box is opened.
///
/// Show content over lights coming from the open box like a magical chest, and layout the content with an levitating animation.
@available(macOS 13.0, iOS 16, *)
public struct OpenBoxContent<Data, Content: View>: View {
    @State
    public var showItems: Bool = false

    @State
    private var isAnimating: Bool = false

    public let data: [Data]

    @ViewBuilder
    public var content: (Data) -> Content

    public init(showItems: Bool = false, isAnimating: Bool = false, data: [Data],
                @ViewBuilder content: @escaping (Data) -> Content) {
        self.showItems = showItems
        self.isAnimating = isAnimating
        self.data = data
        self.content = content
    }

    public var body: some View {
        ZStack {
            if showItems {
                items
                    .transition(.scale(scale: 0.8, anchor: .bottom).combined(with: .opacity))
            } else {
                Rectangle()
                    .foregroundColor(.clear)
            }
        }        .frame(width: 400, height: 300)

        .onAppear {
            withAnimation(.spring(dampingFraction: 0.6)) {
                showItems = true
            }
        }
    }

    var items: some View {
        ZStack {
            BoxContentLayout {
                ForEach(data.indices, id: \.self) { index in
                    let offset1: CGFloat =  index.isMultiple(of: 2) ? 8 : 0
                    let offset2: CGFloat =  index.isMultiple(of: 2) ? 0 : 8

                    content(data[index])
                        .rotationEffect(.degrees(index.isMultiple(of: 2) ? -10 : 10))
                        .offset(y: isAnimating ? offset1 : offset2)
                        .animation(.easeInOut(duration: 1 + Double(index) / 2).repeatForever(), value: isAnimating)

                }
            }
            .drawingGroup()

            .onAppear {
                isAnimating.toggle()
            }
        }
        .offset(y: -190)
        .animation(.easeOut, value: showItems)
    }
}

@available(macOS 13.0, iOS 16, *)
private struct BoxContentLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return proposal.replacingUnspecifiedDimensions()
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {

        let step = bounds.height / Double(max(subviews.count, 1))

        for (index, subview) in subviews.enumerated() {
            let size = bounds.height / 4 - Double(index) * 18
            let proposal = ProposedViewSize(width: size, height: size)

            var point = CGPoint(x: 0, y: -bounds.height)
            point.y += step * Double(index) / 2

            let angle: Angle = .degrees(index.isMultiple(of: 2) ? -10 : 10)
            point = point
                .applying(.init(rotationAngle: angle.radians))
            point.x += bounds.midX
            point.y += bounds.height + bounds.midY

            subview.place(at: point, anchor: .center, proposal: proposal)
        }
    }
}

@available(macOS 13.0, iOS 16, *)
struct OpenBox_Previews: PreviewProvider {
    static var previews: some View {
        OpenBoxContent(data: ["Paypal", "Robinhood", "Passage", "Microsoft"]) { name in
            Image(name, bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}
