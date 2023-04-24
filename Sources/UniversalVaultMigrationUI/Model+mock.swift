//
//  Model+mock.swift
//  
//
//  Created by Jeremy Marchand on 18/04/2023.
//

import Foundation
import UniversalVaultMigration

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
                  userDisplayName: "John",
                  counter: "1",
                  keyAlgorithm: "alg",
                  privateKey: "{\"crv\": \"P-256\", \"d\": \"4oqLQMKD5ZWHO4s68388XH6aO4WGtNb-x_sFa3-mcSg\", \"ext\": true, \"key_ops\": [\"sign\"], \"kty\": \"EC\", \"x\": \"C4NR9sVs17u9smx1qKTk98Kwzu3BLEYeCWOXACgnaP4\", \"y\": \"K5Er7SA3OTOno-b3FBTBgG2Pwi4h83Pk7OZQY073SX8\"}".data(using: .utf8)!)
    }
}
