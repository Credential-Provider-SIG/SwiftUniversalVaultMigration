import Foundation

/// Passkey data representation
public struct Passkey: Codable, Equatable {
    /// Unique identifier (formerly a UUID string, now a sequence of random bytes encoded as a Base64URL string, as of Q1 2023) generated by Dashlane at registration time and sent in all responses to login requests
    public let credentialId: String

    /// Unique identifier (typically a valid domain string) for the Relying Party (the website performing authentication)
    public let relyingPartyId: String

    /// Human-palatable identifier for the Relying Party, intended only for display, provided by the Relying Party
    public let relyingPartyName: String

    /// Unique identifier for a user account, specified by the Relying Party during registration
    public let userHandle: String

    /// Human-palatable name for the user account, intended only for display, provided by the Relying Party
    public let userDiplayName: String

    /// Signature counter incremented for each successful login operation to aid the Relying Party in detecting cloned authenticators
    public let counter: String

    /// Cryptographic algorithm to use when signing with the PrivateKey, encoded as a numerical value registered in the IANA COSE Algorithms registry (https://www.iana.org/assignments/cose/cose.xhtml#algorithms)
    public let keyAlgorithm: String

    /// Private key encoded in JSON Web Key format
    public let privateKey: Data

    public init(credentialId: String,
                relyingPartyId: String,
                relyingPartyName: String,
                userHandle: String,
                userDiplayName: String,
                counter: String,
                keyAlgorithm: String,
                privateKey: Data) {
        self.credentialId = credentialId
        self.relyingPartyId = relyingPartyId
        self.relyingPartyName = relyingPartyName
        self.userHandle = userHandle
        self.userDiplayName = userDiplayName
        self.counter = counter
        self.keyAlgorithm = keyAlgorithm
        self.privateKey = privateKey
    }
}
