//
//  ExportFlowViewModel.swift
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
class ExportFlowViewModel: ObservableObject {
    enum Step: Equatable {
        case preparing(openBox: OpenBox)
        case ready(sealedBox: SealedBox)
    }

    @Published
    var step: Step

    let provider: () -> Vault

    init(openBox: OpenBox, provider: @escaping () -> Vault) {
        self.step = .preparing(openBox: openBox)
        self.provider = provider
        self.prepare(openBox)
    }

    func prepare(_ openBox: OpenBox) {
        Task {
            let vault = provider()
            let sealedBox = try vault.seal(in: openBox)

            self.step = .ready(sealedBox: sealedBox)
        }
    }
}
