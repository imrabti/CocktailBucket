//
//  ContentView.swift
//  Shared
//
//  Created by Mrabti Idriss on 16.06.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        NavigationView {
            Sidebar()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CocktailStore())
    }
}
