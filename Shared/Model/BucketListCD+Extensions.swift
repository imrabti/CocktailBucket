//
//  BucketListCD+Extensions.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 31.05.22.
//

import CoreData

extension BucketListCD {
    var wrappedName: String {
        name ?? ""
    }
    
    var wrappedCocktails: [CocktailCD] {
        (cocktails as? Set<CocktailCD> ?? [])
            .sorted(by: { $0.name ?? "" < $1.name ?? "" })
    }
}
