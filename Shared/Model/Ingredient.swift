//
//  Ingredient.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 16.06.21.
//

import Foundation

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

struct Ingredient: Codable, Identifiable {
    var id: String
    var name: String = ""
    var quantity: Double?
    var unit: Unit = .ml
}
