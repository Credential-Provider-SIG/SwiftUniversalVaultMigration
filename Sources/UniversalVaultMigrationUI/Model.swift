//
//  Model.swift
//  Box
//
//  Created by Jeremy Marchand on 27/03/2023.
//
//  Copyright (c) 2023 Dashlane Inc
//  This software is licensed under the MIT License. See the LICENSE.md file for details.

import Foundation
import UniformTypeIdentifiers
import SwiftUI
import UniversalVaultMigration

public extension UTType {
    static let passwordManagerOpenBox = UTType(mimeType: "application/universalvaultmigration-openbox")!
    static let passwordManagerSealedBox = UTType(mimeType: "application/universalvaultmigration-sealedbox")!
}

extension OpenBox: Transferable {
    @available(macOS 13.0, iOS 16, *)
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: OpenBox.self, contentType: .passwordManagerOpenBox)
    }
}

extension SealedBox: Transferable {
    @available(macOS 13.0, iOS 16, *)
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: SealedBox.self, contentType: .passwordManagerSealedBox)
    }
}

public extension Vault {
    static var mock: Vault {
        self.init(passkeys: [
            .init(name: "Paypal"),
            .init(name: "Robinhood"),
            .init(name: "Passage"),
            .init(name: "Microsoft")
        ])
    }
}

public extension Passkey {
    init(name: String) {
        self.init(credentialId: UUID().uuidString,
                  relyingPartyId: name,
                  relyingPartyName: name,
                  userHandle: UUID().uuidString,
                  userDiplayName: "John",
                  counter: "1",
                  keyAlgorithm: "alg",
                  privateKey: "{\"crv\": \"P-256\", \"d\": \"4oqLQMKD5ZWHO4s68388XH6aO4WGtNb-x_sFa3-mcSg\", \"ext\": true, \"key_ops\": [\"sign\"], \"kty\": \"EC\", \"x\": \"C4NR9sVs17u9smx1qKTk98Kwzu3BLEYeCWOXACgnaP4\", \"y\": \"K5Er7SA3OTOno-b3FBTBgG2Pwi4h83Pk7OZQY073SX8\"}".data(using: .utf8)!)
    }
}

public enum Item: String, Identifiable, Hashable, CaseIterable {
    case passkeys
    case passwords

    public var id: String {
        rawValue
    }
}
