//
//  DropOpenBoxModifier.swift
//  Box
//
//  Created by Jeremy Marchand on 27/03/2023.
//

import SwiftUI
import UniversalVaultMigration

extension View {
    @available(macOS 13.0, iOS 16, *)
    public func passwordManagerSealedBoxProvider(_ provider: @escaping () -> Vault) -> some View {
        self.modifier(DropOpenBoxModifier(provider: provider))
    }
}

@available(macOS 13.0, iOS 16, *)
private struct DropOpenBoxModifier: ViewModifier {
    @State
    var openBox: OpenBox?

    let provider: () -> Vault

    func body(content: Content) -> some View {
        content
            .dropDestination(for: OpenBox.self) { items, _ in
                guard let item = items.first else {
                    return false
                }

                openBox = item
                return true
            }
            .sheet(item: $openBox) { openBox in
                ExportFlow(openBox: openBox, provider: provider)
            }
            .animation(.easeOut, value: openBox)
    }
}

extension OpenBox: Identifiable {
    public var id: Data {
        return self.publicKey.rawRepresentation
    }
}
