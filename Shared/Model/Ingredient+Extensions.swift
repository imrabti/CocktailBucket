//
//  Ingredient+Extensions.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 01.06.22.
//

import CoreData

enum Unit: String, Codable, CaseIterable {
    case teeSpoon
    case tableSpoon
    case ml
    case cl
    case piece
    
    var label: String {
        switch self {
        case .teeSpoon:
            return "tsp"
        case .tableSpoon:
            return "tbsp"
        default:
            return self.rawValue
        }
    }
    
    func format(_ quantity: Double?) -> String {
        guard let quantity = quantity else { return "0 \(label)" }
        return "\(quantity) \(label)"
    }
}

extension Ingredient {
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
