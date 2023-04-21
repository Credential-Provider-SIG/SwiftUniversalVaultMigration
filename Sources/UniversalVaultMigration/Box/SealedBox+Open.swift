// Copyright (c) 2023 Dashlane Inc
// This software is licensed under the MIT License. See the LICENSE.md file for details.

import Foundation
import CryptoKit

public extension SealedBox {
    /// Open the current SealedBox with the given vault receiver private key
    /// - Parameters:
    ///   - privateKey: Private key of the vault receiver.
    /// - Returns: A decrypted Vault
    /// - throws: ``OpenError.couldNotOpenSealedBox`` if the sealed vault data cannot be opened using the AES.GCM function.
    /// - throws: ``OpenError.couldNotDecodeSealedBox`` if the Vault cannot be decoded from JSON.
    func open(using privateKey: PrivateKey) throws -> Vault {
        // Generate the symmetric key between the currently generated private key and the sealedBox public key
        let symmetricKey = try privateKey.symmetricKey(with: publicKey, salt: keyDerivationSalt)
        // Decrypt the sealed box to get the vault
        let vault = try open(using: symmetricKey)
        return vault
    }
}

/// Error for the opening sealed box method.
public enum OpenError: Error {
    /// The sealed vault data cannot be opened using the AES.GCM function.
    case couldNotOpenSealedBox(CryptoKitError)
    /// The Vault cannot be decoded from JSON.
    case couldNotDecodeSealedBox(DecodingError)
}

private extension SealedBox {
    func open(using symmetricKey: SymmetricKey) throws -> Vault {
        do {
            // Open the SealedBox
            let box = try AES.GCM.SealedBox(nonce: AES.GCM.Nonce(data: encryptionNonce),
                                            ciphertext: encryptedVault,
                                            tag: authenticationTag)
            let decryptedData = try AES.GCM.open(box, using: symmetricKey)
            return try JSONDecoder().decode(Vault.self, from: decryptedData)
        } catch let error as CryptoKitError {
            throw OpenError.couldNotOpenSealedBox(error)
        } catch let error as DecodingError {
            throw OpenError.couldNotDecodeSealedBox(error)
        }
    }
}
