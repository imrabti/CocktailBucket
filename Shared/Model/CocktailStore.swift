//
//  CocktailStore.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 16.06.21.
//

import Foundation

final class CocktailStore: ObservableObject {
    @Published var buckets: [BucketList] = []
    
    init() {
        buckets.append(contentsOf: [
            BucketList(id: UUID().uuidString, name: "⛱ Sommer", cocktails: [
                Cocktail(id: UUID().uuidString,
                         name: "Mojito",
                         alcohol: true,
                         picture: "file:////Users/imrabti/Downloads/mojito.jpg",
                         ingredients: [
                            Ingredient(id: UUID().uuidString, name: "White Rum", quantity: 4, unit: .cl),
                            Ingredient(id: UUID().uuidString, name: "Sugar", quantity: 2, unit: .tableSpoon),
                            Ingredient(id: UUID().uuidString, name: "Lime Juice", quantity: 3, unit: .cl),
                            Ingredient(id: UUID().uuidString, name: "Club Soda", quantity: 6, unit: .cl),
                            Ingredient(id: UUID().uuidString, name: "Mint Leaves", quantity: 6, unit: .piece),
                            Ingredient(id: UUID().uuidString, name: "Crushed Ice", quantity: 4, unit: .piece),
                         ],
                         steps: [
                            Step(id: UUID().uuidString, value: "Add **Sugar** *Mint leaves* to the Collins Glass"),
                            Step(id: UUID().uuidString, value: "Pour Lime Juice into the Glass"),
                            Step(id: UUID().uuidString, value: "Crush **Lime Juice** Sugar Mint Leaves with Muddler"),
                            Step(id: UUID().uuidString, value: "Fill up the Glass with Crushed Ice"),
                            Step(id: UUID().uuidString, value: "Pour White Rum into the Glass")
                         ]),
                Cocktail(id: UUID().uuidString,
                         name: "Aperol Spritz",
                         alcohol: true,
                         picture: "file:////Users/imrabti/Downloads/aperol.jpg",
                         ingredients: [
                            Ingredient(id: UUID().uuidString, name: "Aperol", quantity: 3, unit: .cl),
                            Ingredient(id: UUID().uuidString, name: "Prosecco", quantity: 6, unit: .cl),
                            Ingredient(id: UUID().uuidString, name: "Club Soda", quantity: 3, unit: .cl)
                         ],
                         steps: [
                            Step(id: UUID().uuidString, value: "Add Ice to the Glass"),
                            Step(id: UUID().uuidString, value: "Pour Aperol Prosecco Club Soda into the Glass"),
                            Step(id: UUID().uuidString, value: "Stir together"),
                            Step(id: UUID().uuidString, value: "Garnish with Orange Slice")
                         ]),
                Cocktail(id: UUID().uuidString,
                         name: "Salty Puppy",
                         alcohol: false,
                         picture: "file:////Users/imrabti/Downloads/salty_puppy.jpg",
                         ingredients: [
                            Ingredient(id: UUID().uuidString, name: "Grapefruit Juice", quantity: 9, unit: .cl),
                            Ingredient(id: UUID().uuidString, name: "Tonic", quantity: 3, unit: .cl),
                            Ingredient(id: UUID().uuidString, name: "Ice", quantity: 4, unit: .piece)
                         ],
                         steps: [
                            Step(id: UUID().uuidString, value: "Garnish with Salt"),
                            Step(id: UUID().uuidString, value: "Pour Grapefruit Juice Tonic into the Glass")
                         ]),
            ]),
            BucketList(id: UUID().uuidString, name: "🎉 Celebration", cocktails: []),
            BucketList(id: UUID().uuidString, name: "🧑🏻‍💻 Productivity", cocktails: [])
        ])
    }
    
    subscript(bucketListId: BucketList.ID?) -> BucketList {
        get {
            if let id = bucketListId {
                return buckets.first(where: { $0.id == id }) ?? .defaultBucketList
            }
            return .defaultBucketList
        }

        set(newValue) {
            if let id = bucketListId {
                buckets[buckets.firstIndex(where: { $0.id == id })!] = newValue
            }
        }
    }
}
