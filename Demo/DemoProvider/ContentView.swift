//
//  ContentView.swift
//  DemoProvider
//
//  Created by Jeremy Marchand on 30/03/2023.
//

import SwiftUI
import UniversalVaultMigrationUI

struct ContentView: View {
    var body: some View {
        MainView(vault: .mock)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
