//
//  Sidebar.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 16.06.21.
//

import SwiftUI
import CoreData

struct Sidebar: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BucketListCD.created, ascending: true)])
    private var buckets: FetchedResults<BucketListCD>
    
    @State private var addNewItem = false
    @State private var name: String = ""
    @State private var itemToAddOrEdit: BucketListCD?
    @FocusState private var focus: String?
    
    var body: some View {
        List {
            ForEach(buckets) { bucketList in
                if bucketList == itemToAddOrEdit {
                    TextField("Name", text: $name)
                        .focused($focus, equals: "name")
                        .onSubmit {
                            itemToAddOrEdit?.name = name
                            try? viewContext.save()
                            itemToAddOrEdit = nil
                            focus = nil
                            name = ""
                        }
                } else {
                    NavigationLink(bucketList.wrappedName) {
                        BucketListDetail(bucketList: bucketList)
                    }
                    .badge(bucketList.cocktails?.count ?? 0)
                    .swipeActions {
                        Button {
                            itemToAddOrEdit = bucketList
                            name = itemToAddOrEdit?.name ?? ""
                            focus = "name"
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.gray)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button {
                            viewContext.delete(bucketList)
                            try? viewContext.save()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                }
            }
        }
        .navigationTitle("Buckets")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    itemToAddOrEdit = BucketListCD(context: viewContext)
                    itemToAddOrEdit?.created = Date()
                    try? viewContext.save()
                    focus = "name"
                } label: {
                    Label("Add new", systemImage: "plus")
                }
            }
        }
        .listStyle(.sidebar)
    }
}
