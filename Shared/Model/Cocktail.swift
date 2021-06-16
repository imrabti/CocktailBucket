//
//  Cocktail.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 16.06.21.
//

import Foundation

struct Cocktail: Codable, Identifiable {
    var id: String?
    var name: String = ""
    var alcohol: Bool = false
    var picture: String?
    var ingredients: [Ingredient] = []
    var steps: [Step] = []
}

extension Cocktail {
    static var defaultCocktail: Self {
        Cocktail()
    }
}
