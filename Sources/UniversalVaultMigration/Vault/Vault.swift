import Foundation

/// Representation of a user's vault.
public struct Vault: Codable, Equatable {

    /// A list of all Passkeys of the account.
    public var passkeys: [Passkey]

    public init(passkeys: [Passkey] = []) {
        self.passkeys = passkeys
    }
}
