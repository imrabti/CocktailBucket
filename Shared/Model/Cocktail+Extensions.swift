//
//  Cocktails+Extensions.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 31.05.22.
//

import CoreData

extension Cocktail {
    var wrappedName: String {
        name ?? ""
    }
    
    var wrappedIngredients: [Ingredient] {
        (ingredients as? Set<Ingredient> ?? [])
            .sorted(by: { $0.wrappedName < $1.wrappedName })
    }
    
    var wrappedSteps: [Step] {
        (steps as? Set<Step> ?? [])
            .sorted(by: { $0.wrappedStep < $1.wrappedStep })
    }
    
    var wrappedAttachment: Attachment? {
        (attachments as? Set<Attachment> ?? []).first
    }
}
