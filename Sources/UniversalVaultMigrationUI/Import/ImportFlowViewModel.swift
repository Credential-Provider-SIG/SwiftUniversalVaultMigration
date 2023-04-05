//
//  ImportFlowViewModel.swift
//  Box
//
//  Created by Jeremy Marchand on 27/03/2023.
//
//  Copyright (c) 2023 Dashlane Inc
//  This software is licensed under the MIT License. See the LICENSE.md file for details.

import Foundation
import SwiftUI
import UniversalVaultMigration

@MainActor
@available(macOS 13.0, iOS 16, *)
class ImportFlowViewModel: ObservableObject {
    enum Step: Equatable {
        case preparing
        case waiting
        case importing(_ sealedBox: SealedBox)
        case ready(_ ready: Vault)
    }

    @Published
    var step: Step = .preparing

    let privateKey = PrivateKey()

    let completion: (Vault) -> Void

    init(completion: @escaping (Vault) -> Void) {
        self.completion = completion
    }

    init(initialStep: Step, completion: @escaping (Vault) -> Void) {
        self.step = initialStep
        self.completion = completion
    }

    func makeOpenBox() -> OpenBox {
        Task {
            step = .waiting
        }
        return OpenBox(publicKey: privateKey.publicKey)
    }

    func `import`(_ sealedBox: SealedBox) -> Bool {
        step = .importing(sealedBox)

        Task {
            let vault = try sealedBox.open(using: privateKey)
            step = .ready(vault)
        }

        return true
    }
}
