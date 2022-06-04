//
//  BucketListCD+Extensions.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 31.05.22.
//

import CoreData

extension BucketList {
    var wrappedName: String {
        name ?? ""
    }
    
    var wrappedCocktails: [Cocktail] {
        (cocktails as? Set<Cocktail> ?? [])
            .sorted(by: { $0.wrappedName < $1.wrappedName })
    }
}
