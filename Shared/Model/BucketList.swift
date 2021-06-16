//
//  BucketList.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 16.06.21.
//

import Foundation

struct BucketList: Codable, Identifiable {
    var id: String
    var name: String
    var cocktails: [Cocktail]
    
    subscript(cocktailId: Cocktail.ID?) -> Cocktail {
        get {
            if let id = cocktailId {
                return cocktails.first(where: { $0.id == id }) ?? .defaultCocktail
            }
            return .defaultCocktail
        }

        set(newValue) {
            if let id = cocktailId {
                guard let index = cocktails.firstIndex(where: { $0.id == id }) else {
                    cocktails.append(newValue)
                    return
                }
                cocktails[index] = newValue
            }
        }
    }
}

extension BucketList {
    static var defaultBucketList: Self {
        BucketList(id: UUID().uuidString, name: "New List", cocktails: [])
    }
}
