import XCTest
@testable import UniversalVaultMigration
import CryptoKit

final class UniversalVaultMigrationTests: XCTestCase {
    func testSharingSymmetricKeyBetweenTwoKeyPair() throws {

        let privateKey1 = PrivateKey()
        let privateKey2 = PrivateKey()

        let salt = "salt".data(using: .utf8)!

        let symmetricKey1 = try privateKey1.symmetricKey(with: privateKey2.publicKey, salt: salt)
        let symmetricKey2 = try privateKey2.symmetricKey(with: privateKey1.publicKey, salt: salt)

        XCTAssertEqual(symmetricKey1, symmetricKey2)
    }

    func testFlow() throws {
        // App1 - Initiates import
        // App1 - Create the keys
        // App1 - Creates an OpenBox with crypto information
        let app1PrivateKey = PrivateKey()
        let app1OpenBox = OpenBox(publicKey: app1PrivateKey.publicKey)

        //
        // Transfer the OpenBox via any Transport layer
        //

        // App2 - Generate the keys based on the crypto from the App1 file
        // App2 - Create a symmetric key with PubApp1 + PrivApp2
        // App2 - Encrypts the data using the symmetric key
        // App2 - Created a SealedBox
        let app2Vault = Vault.mock
        let sealedBox = try app2Vault.seal(in: app1OpenBox)

        //
        // Transfer the SealedBox to app1
        //

        // App1 - Create a symmetric key with PrivApp1 + PubApp2
        // App1 - Decrypt sealedbox using the key
        let receivedVault = try sealedBox.open(using: app1PrivateKey)

        // Magic happened
        XCTAssertEqual(receivedVault, app2Vault)
    }
}

private extension Vault {
    static var mock: Vault {
        self.init(passkeys: [
            .init(name: "Microsoft"),
            .init(name: "webauthn")
        ])
    }
}

private extension Passkey {
    init(name: String) {
        self.init(credentialId: UUID().uuidString,
                  relyingPartyId: name,
                  relyingPartyName: name,
                  userHandle: UUID().uuidString,
                  userDisplayName: UUID().uuidString,
                  counter: "1",
                  keyAlgorithm: "alg",
                  privateKey: "key".data(using: .utf8)!)
    }

}
