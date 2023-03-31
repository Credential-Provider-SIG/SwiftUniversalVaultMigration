//
//  Sidebar.swift
//  DemoProvider
//
//  Created by Jeremy Marchand on 30/03/2023.
//

import SwiftUI

@available(macOS 13.0, iOS 16, *)
struct Sidebar: View {
    @Binding
    var selection: Item?

    var body: some View {
        List(selection: $selection) {
            Section("Vault") {
                ForEach(Item.allCases) { item in
                    NavigationLink(value: item) {
                        Label {
                            Text(item.rawValue.capitalized)
                        } icon: {
                            Image(item)
                        }
                        .tag(item.rawValue)
                    }
                }
            }
        }.listStyle(.sidebar)

    }
}

@available(macOS 13.0, iOS 16, *)
struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSplitView {
            Sidebar(selection: .constant(.passkeys))
        } detail: {
            EmptyView()
        }

    }
}

extension Image {
    init(_ item: Item) {
        switch item {
        case .passkeys:
            self.init(systemName: "key.horizontal.fill")
        case .passwords:
            self.init(systemName: "character.textbox")
        }
    }
}
