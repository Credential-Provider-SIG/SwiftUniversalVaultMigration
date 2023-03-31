//
//  ContentView.swift
//  Demo
//
//  Created by Jeremy Marchand on 30/03/2023.
//

import SwiftUI
import UniversalVaultMigrationUI
import UniversalVaultMigration

struct ContentView: View {
    var body: some View {
        MainView(vault: Vault())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
