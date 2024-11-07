//
//  HPTriviaApp.swift
//  HPTrivia
//
//  Created by Weerawut Chaiyasomboon on 6/11/2567 BE.
//

import SwiftUI

@main
struct HPTriviaApp: App {
    @StateObject private var store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .task {
                    await store.loadProducts()
                }
        }
    }
}
