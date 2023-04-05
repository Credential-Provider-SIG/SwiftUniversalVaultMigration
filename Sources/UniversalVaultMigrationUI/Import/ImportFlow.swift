//
//  ImportFlow.swift
//  Box
//
//  Created by Jeremy Marchand on 27/03/2023.
//
//  Copyright (c) 2023 Dashlane Inc
//  This software is licensed under the MIT License. See the LICENSE.md file for details.

import SwiftUI
import UniversalVaultMigration

@available(macOS 13.0, iOS 16, *)
public struct ImportFlow: View {
    let infoOffset: Double = -280

    @StateObject
    var model: ImportFlowViewModel

    @State
    var isTargeted: Bool = false

    @Environment(\.dismiss)
    var dismiss

    public init(completion: @escaping (Vault) -> Void) {
        self._model = .init(wrappedValue: ImportFlowViewModel(completion: completion))
    }

    init(model: @autoclosure @escaping () -> ImportFlowViewModel) {
        self._model = .init(wrappedValue: model())
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
                    preparing
                case .waiting:
                    waiting
                case .importing, .ready:
                    importing
                }
            }
            .padding(.top, 60)
            .animation(.easeInOut, value: model.step)
            .frame(width: 450, height: 550)

        }

    }

    @ViewBuilder
    var preparing: some View {
        Box(isSealed: false, isLevitating: false)
            .draggable(model.makeOpenBox()) {
                Image("Open", bundle: .module)
                    .frame(height: 300)
            }

        InfoArea(title: "Ready to Move In?",
                 message: "Drag and drop the empty box to your previous password manager")
        .offset(x: 0, y: infoOffset)
    }

    @ViewBuilder
    var waiting: some View {

        let scale = isTargeted ? 1 : 0.8
        let opacity = isTargeted ? 1 : 0.8

        Image("Drop", bundle: .module)
            .opacity(opacity)
            .scaleEffect(.init(width: scale, height: scale))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .dropDestination(for: SealedBox.self) { items, _ in
                guard let item = items.first else {
                    return false
                }

                return model.import(item)
            } isTargeted: { isTargeted in
                self.isTargeted = isTargeted
            }
            .animation(.interactiveSpring(), value: isTargeted)
            .frame(height: 300)

        InfoArea(title: "Almost done!",
                 message: "Drop the sealed box from your previous password manager")
        .offset(x: 0, y: infoOffset)

    }

    @ViewBuilder
    var importing: some View {

        DroppingBox {
            MagicalLight()
                .offset(y: -100)
                .overlay {
                    if case .ready = model.step {
                        OpenBoxContent(data: ["Paypal", "Robinhood", "Passage", "Microsoft"]) { name in
                            Image(name, bundle: .module)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
        }

        if case let .ready(vault) = model.step {
            InfoArea(title: "Enjoy!",
                     message: "Import the content to your vault")
            .offset(x: 0, y: infoOffset)
            Button("Import") {
                model.completion(vault)
            }
            .offset(x: 0, y: 200)
            .buttonStyle(.action)
        } else {

            InfoArea(title: "Importing...",
                     message: " ")
            .offset(x: 0, y: infoOffset)
        }
    }
}

@available(macOS 13.0, iOS 16, *)
struct ImportFlow_Previews: PreviewProvider {
    static var previews: some View {
        ImportFlow { _ in

        }
        .previewDisplayName("Preparing")

        ImportFlow(model: .init(initialStep: .waiting, completion: { _  in

        }))
        .previewDisplayName("Waiting")

        ImportFlow(model: .init(initialStep: .importing(.init(publicKey: PrivateKey().publicKey, encryptedVault: Data(), keyDerivationSalt: Data())), completion: { _  in

        }))
        .previewDisplayName("Importing")

        ImportFlow(model: .init(initialStep: .ready(Vault(passkeys: [])), completion: { _  in

        }))
        .previewDisplayName("Ready")

    }
}
