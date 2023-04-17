//
//  MainView.swift
//  DemoProvider
//
//  Created by Jeremy Marchand on 30/03/2023.
//
//  Copyright (c) 2023 Dashlane Inc
//  This software is licensed under the MIT License. See the LICENSE.md file for details.

import SwiftUI
import UniversalVaultMigration

public enum Item: String, Identifiable, Hashable, CaseIterable {
    case passkeys
    case passwords

    public var id: String {
        rawValue
    }
}

@available(macOS 13.0, iOS 16, *)
public struct MainView: View {
    @State
    public var vault: Vault

    @State
    var selection: Item? = .passkeys

    @State
    var showImport: Bool = false

    @State
    var showClearAllConformation: Bool = false

    public init(vault: Vault) {
        self.vault = vault
    }

    public var body: some View {
        NavigationSplitView {
            Sidebar(selection: $selection)
        } detail: {
            switch selection {
            case .passkeys:
                PasskeysList(passkeys: vault.passkeys)
                    .overlay {
                        empty
                    }
            default:
                EmptySection()
            }
        }
        .passwordManagerSealedBoxProvider {
            vault
        }
        .sheet(isPresented: $showImport) {
            ImportFlow { vault in
                self.vault = vault
                showImport = false
            }
        }
        .toolbar {
            Button {
                showClearAllConformation = true
            } label: {
                Image(systemName: "trash")
            }
        }
        .confirmationDialog("Are you sure you want to delete all the content of your Vault?", isPresented: $showClearAllConformation) {
            Button("Delete all the vault", role: .destructive) {
                self.vault = .init()
            }

            Button("Cancel", role: .cancel) {

            }
        }
    }

    @ViewBuilder
    var empty: some View {
        if vault.passkeys.isEmpty {
            VStack(spacing: 20) {
                Text("Move the vault from your previous password manager")
                    .font(.title3.weight(.medium))
                    .frame(maxWidth: 200)
                    .multilineTextAlignment(.center)
                Image("Drop", bundle: .module)
                    .renderingMode(.template)
                    .foregroundColor(.secondary)

                Button("Import") {
                    showImport = true
                }.buttonStyle(ActionButtonStyle())
            }
        }
    }
}

struct EmptySection: View {
    var body: some View {
        List { }
            .overlay {
                Text("Nothing here!")
                    .foregroundColor(.secondary)
            }
    }
}

@available(macOS 13.0, iOS 16, *)
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(vault: .mock)
            .previewDisplayName("Provider")
        MainView(vault: .init())
            .previewDisplayName("Receiver")
    }
}
