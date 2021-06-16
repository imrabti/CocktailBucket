//
//  Sidebar.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 16.06.21.
//

import SwiftUI

struct Sidebar: View {
    @EnvironmentObject var store: CocktailStore
    
    var body: some View {
        List($store.buckets) { $bucketList in
            NavigationLink(bucketList.name) {
                BucketListDetail(bucketList: $bucketList)
            }
            .badge(bucketList.cocktails.count)
        }
        .navigationTitle("Buckets")
        .listStyle(.sidebar)
    }
}
