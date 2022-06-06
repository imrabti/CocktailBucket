//
//  BucketListDetail.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 16.06.21.
//

import SwiftUI

struct BucketListDetail: View {
    
    @Environment(\.isSearching) private var isSearching
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Cocktail.name, ascending: true)])
    private var cocktails: FetchedResults<Cocktail>
    
    @State private var search = ""
    @State private var editMode = false
    @State private var currentCocktail: Cocktail?
    
    var bucketList: BucketList
    var predicate: NSPredicate
    
    init(bucketList: BucketList) {
        self.bucketList = bucketList
        self.predicate = NSPredicate(format: "bucketList == %@", bucketList)
    }
    
    var body: some View {
        List {
            ForEach(cocktails, id: \.self) { cocktail in
                NavigationLink {
                    CocktailView(cocktail: cocktail)
                } label: {
                    HStack(spacing: 8) {
                        CocktailPictureView(
                            size: 50,
                            placeholderBackgroundColor: Color(uiColor: .secondarySystemBackground),
                            picture: .constant(cocktail.wrappedAttachment?.getThumbnail())
                        )
                        VStack(alignment: .leading) {
                            Text(cocktail.wrappedName)
                            
                            HStack {
                                ForEach(cocktail.wrappedIngredients.prefix(4)) { ingredient in
                                    Text(ingredient.wrappedName)
                                        .font(.caption).bold()
                                        .padding(3)
                                        .foregroundColor(Color.white)
                                        .background(Color.accentColor.opacity(0.6))
                                        .cornerRadius(6)
                                }
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
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button {
                        viewContext.delete(cocktail)
                        try? viewContext.save()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                }
            }
        }
        .searchable(text: $search)
        .navigationTitle(bucketList.wrappedName)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    editMode = true
                    currentCocktail = Cocktail(context: viewContext)
                    currentCocktail?.bucketList = bucketList
                } label: {
                    Label("Add new", systemImage: "plus")
                }
            }
        }
        .onChange(of: search) { newValue in
            var predicates = [predicate]
            if !newValue.isEmpty {
                predicates.append(NSPredicate(format: "name CONTAINS[cd] %@", newValue))
            }
            
            cocktails.nsPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        .onAppear { cocktails.nsPredicate = predicate }
        .sheet(isPresented: $editMode) {
            EditCocktail(cocktail: $currentCocktail)
        }
    }
}
