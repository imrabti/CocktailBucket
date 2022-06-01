//
//  Ingredient+Extensions.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 01.06.22.
//

import CoreData

extension IngredientCD {
    var wrappedName: String {
        name ?? ""
    }
    
    var unitEnum: Unit {
        get {
            guard let unit = unit else { return .ml }
            return Unit(rawValue: unit) ?? Unit.ml
        }
        set { self.unit = newValue.rawValue }
    }
}
