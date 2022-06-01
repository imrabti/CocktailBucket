//
//  Cocktails+Extensions.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 31.05.22.
//

import CoreData

extension CocktailCD {
    var wrappedName: String {
        name ?? ""
    }
    
    var wrappedIngredients: [IngredientCD] {
        (ingredients as? Set<IngredientCD> ?? [])
            .sorted(by: { $0.wrappedName < $1.wrappedName })
    }
    
    var wrappedSteps: [StepCD] {
        (steps as? Set<StepCD> ?? [])
            .sorted(by: { $0.wrappedStep < $1.wrappedStep })
    }
}
