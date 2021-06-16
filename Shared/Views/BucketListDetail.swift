//
//  BucketListDetail.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 16.06.21.
//

import SwiftUI

struct BucketListDetail: View {
    
    @Environment(\.isSearching) var isSearching
    
    @Binding var bucketList: BucketList
    
    @State private var search = ""
    @State private var editMode = false
    @State private var currentCocktail = Cocktail()
    
    var cocktails: [Cocktail] {
        guard !search.isEmpty else { return bucketList.cocktails}
        return bucketList.cocktails.filter { $0.name.localizedCaseInsensitiveContains(search) }
    }
    
    var body: some View {
        List {
            ForEach(cocktails) { cocktail in
                NavigationLink {
                    CocktailView(cocktail: cocktail)
                } label: {
                    VStack(alignment: .leading) {
                        Text(cocktail.name)
                        
                        HStack {
                            ForEach(cocktail.ingredients.prefix(4)) { ingredient in
                                Text(ingredient.name)
                                    .font(.caption).bold()
                                    .padding(3)
                                    .foregroundColor(Color.white)
                                    .background(Color.accentColor.opacity(0.6))
                                    .cornerRadius(6)
                            }
                        }
                    }
                }
                .swipeActions {
                    Button {
                        editMode = true
                        currentCocktail = cocktail
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.gray)
                }
            }
        }
        .searchable(text: $search)
        .navigationTitle(bucketList.name)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    editMode = true
                    currentCocktail = Cocktail()
                } label: {
                    Label("Add new", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $editMode) {
            EditCocktail(bucketList: $bucketList, cocktail: $currentCocktail)
        }
    }
}
