//
//  ExportFlow.swift
//  Box
//
//  Created by Jeremy Marchand on 27/03/2023.
//
//  Copyright (c) 2023 Dashlane Inc
//  This software is licensed under the MIT License. See the LICENSE.md file for details.

import SwiftUI
import UniversalVaultMigration

@MainActor
@available(macOS 13.0, iOS 16, *)
public struct ExportFlow: View {
    @StateObject
    var model: ExportFlowViewModel

    @Environment(\.dismiss)
    var dismiss

    @State
    var hasDrop: Bool = false

    @State
    var dragging: Bool = false

    public init(openBox: OpenBox, provider: @escaping () -> Vault) {
        self._model = .init(wrappedValue: ExportFlowViewModel(openBox: openBox, provider: provider))
    }

    public var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .padding()
                .buttonStyle(.borderless)
                Spacer()
            }
            ZStack {
                switch model.step {
                case .preparing:

                    InfoArea(title: "Ready to Move!",
                             message: "Drag and drop the sealed box to your new password manager")
                    .offset(y: -230)

                    Box(isSealed: false, isLevitating: true)
                case  let .ready(sealedBox):
                    InfoArea(title: "All Set!",
                             message: "Drag and drop the sealed box to your new password manager")
                    .offset(y: -230)

                    DroppingBox(isSealed: false) {

                    }
                    .draggable({ () -> SealedBox in
                        Task {
                            dismiss()
                        }

                        return sealedBox
                    }()) {
                        Image("Sealed", bundle: .module)
                            .frame(height: 300)
                    }
                }
            }.frame(width: 450, height: 500)
        }
        .presentationDetents([.medium])
    }
}

@available(macOS 13.0, iOS 16, *)
struct ExportFlow_Previews: PreviewProvider {
    static var previews: some View {
        ExportFlow(openBox: .init(publicKey: PrivateKey().publicKey)) {
            Vault(passkeys: [])
        }
    }
}
