// Copyright (c) 2023 Dashlane Inc
// This software is licensed under the MIT License. See the LICENSE.md file for details.

import Foundation
import CryptoKit

extension PrivateKey {
    /// Elliptic curve Diffie Hellman (ECDH) symmetric Key
    func symmetricKey(with publicKey: PublicKey, salt: Data, outputByteCount: Int = 32) throws -> SymmetricKey {
        let sharedSecret = try self.sharedSecretFromKeyAgreement(with: publicKey)
        return sharedSecret.hkdfDerivedSymmetricKey(
            using: SHA256.self,
            salt: salt,
            sharedInfo: Data(),
            outputByteCount: outputByteCount
        )
    }
}
