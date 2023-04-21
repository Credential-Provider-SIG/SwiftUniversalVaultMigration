// Copyright (c) 2023 Dashlane Inc
// This software is licensed under the MIT License. See the LICENSE.md file for details.

import Foundation
import CryptoKit

public extension Vault {
    /// Seals the Vault inside the given ``OpenBox``.
    /// - Parameter vault: OpenBox received from the other application
    /// - Returns: ``SealedBox``containing the sealed data and crypto information
    /// - throws: ``SealingError.couldNotSealData`` if the JSON data cannot be sealed using the AES.GCM function
    /// - throws: ``SealingError.couldNotEncodeData`` if the Vault cannot be encoded to JSON
    func seal(in openBox: OpenBox) throws -> SealedBox {
        do {
            // Generate an asymmetric key pair
            let privateKey = PrivateKey()

            // Generate the symmetric key between the currently generated private key and the received public key
            let salt = Data.random(ofSize: 32)
            let symmetricKey = try privateKey.symmetricKey(with: openBox.publicKey, salt: salt)

            // Seal the vault using the symmetric key
            let encryptedData = try self.seal(using: symmetricKey)

            // Generate the sealed box
            return SealedBox(publicKey: privateKey.publicKey,
                             encryptedVault: encryptedData.data,
                             keyDerivationSalt: salt,
                             encryptionNonce: Data(encryptedData.encryptionNonce),
                             authenticationTag: encryptedData.authenticationTag)

        } catch let error as EncodingError {
            throw SealingError.couldNotEncodeData(error)
        }

    }

    private func seal(using symmetricKey: SymmetricKey) throws -> EncryptedData {
        do {
            // Encode the vault into JSON
            let encodedVault = try JSONEncoder().encode(self)
            // Encrypt the vault using the symmetric key
            let encryptedVaultData = try AES.GCM.seal(encodedVault, using: symmetricKey)

            return EncryptedData(encryptionNonce: encryptedVaultData.nonce,
                                 authenticationTag: encryptedVaultData.tag,
                                 data: encryptedVaultData.ciphertext)
        } catch let error as EncodingError {
            throw SealingError.couldNotEncodeData(error)
        } catch let error as CryptoKitError {
            throw SealingError.couldNotSealData(error)
        }
    }
}

/// Error for sealing vault method.
public enum SealingError: Error {
    /// the Vault cannot be encoded to JSON.
    case couldNotEncodeData(EncodingError)
    /// The Vault JSON data cannot be sealed using the AES.GCM function.
    case couldNotSealData(CryptoKitError?)
}

private struct EncryptedData {
    /// Nonce used to encrypt the data
    let encryptionNonce: AES.GCM.Nonce
    /// Authentication of the ciphered data
    let authenticationTag: Data
    /// Encrypted data
    let data: Data
}

private extension Data {
    static func random(ofSize size: Int) -> Data {
        var bytes = [Int8](repeating: 0, count: size)
        _ = SecRandomCopyBytes(kSecRandomDefault, size, &bytes)
        return .init(bytes: bytes, count: size)
    }
}
