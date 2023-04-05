//
//  PasskeysList.swift
//  DemoProvider
//
//  Created by Jeremy Marchand on 30/03/2023.
//
//  Copyright (c) 2023 Dashlane Inc
//  This software is licensed under the MIT License. See the LICENSE.md file for details.

import SwiftUI
import UniversalVaultMigration

struct PasskeysList: View {
    let passkeys: [Passkey]

    var body: some View {
        List(passkeys) { passkey in
            HStack {
                Image(systemName: "key.horizontal.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(4)
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 8, style: .continuous).foregroundStyle(.yellow))
                    .padding(2)

                VStack(alignment: .leading, spacing: 3) {
                    Text(passkey.relyingPartyName)
                        .font(.body.weight(.medium))
                        .foregroundColor(.primary)
                    Text(passkey.userDiplayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

            }
            Divider()
        }
    }
}

struct PasskeysList_Previews: PreviewProvider {
    static var previews: some View {
        PasskeysList(passkeys: Vault.mock.passkeys)
    }
}

extension Passkey: Identifiable {
    public var id: String {
        self.credentialId
    }
}
