//
//  CocktailBucketApp.swift
//  Shared
//
//  Created by Mrabti Idriss on 16.06.21.
//

import SwiftUI

@main
struct CocktailBucketApp: App {
    @StateObject private var store = CocktailStore()
    @StateObject private var persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(store)
        }
    }
}
