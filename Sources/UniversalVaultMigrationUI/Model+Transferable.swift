//
//  Model+Transferable.swift
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

@available(macOS 13.0, *)
extension ProxyRepresentation where Item: Codable, ProxyRepresentation == URL {
    init(filenameExtension: String) {
        self.init { item in
            let name = Bundle.main.infoDictionary!["CFBundleName"] as! String
            let file = URL.temporaryDirectory.appendingPathComponent("\(name).\(filenameExtension)")
            let data = try JSONEncoder().encode(item)
            try data.write(to: file)
            return file
        }
    }
}

extension OpenBox: Transferable {
    @available(macOS 13.0, iOS 16, *)
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: OpenBox.self, contentType: .passwordManagerOpenBox)
        ProxyRepresentation(filenameExtension: "openbox")
    }
}

extension SealedBox: Transferable {
    @available(macOS 13.0, iOS 16, *)
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: SealedBox.self, contentType: .passwordManagerSealedBox)
        ProxyRepresentation(filenameExtension: "sealedbox")
    }
}



