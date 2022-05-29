//
//  EditCocktail.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 16.06.21.
//

import SwiftUI

struct EditCocktail: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var bucketList: BucketList
    @Binding var cocktail: Cocktail
    
    @State private var ingredientsExpanded = true
    @State private var stepsExpanded = true
    
    @FocusState private var focus: String?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $cocktail.name)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                        .focused($focus, equals: "Name")

                    Toggle("Contain alcohol 🥴", isOn: $cocktail.alcohol)
                }
                
                DisclosureGroup(isExpanded: $ingredientsExpanded) {
                    VStack {
                        List($cocktail.ingredients) { $ingredient in
                            IngredientView(ingredient: $ingredient)
                        }
                        Button("Add Ingredient") {
                            cocktail.ingredients.append(Ingredient(id: UUID().uuidString))
                        }
                    }
                } label: {
                    Text("Ingredients").font(.title3).bold()
                }
                
                DisclosureGroup(isExpanded: $stepsExpanded) {
                    VStack {
                        List($cocktail.steps) { $step in
                            VStack{
                                TextEditor(text: $step.value)
                                    .focused($focus, equals: step.id)
                                Divider()
                            }
                        }
                        Button("Add Step") {
                            let id = UUID().uuidString
                            cocktail.steps.append(Step(id: id))
                            focus = id
                        }
                    }
                } label: {
                    Text("Steps").font(.title3).bold()
                }
            }
            .navigationTitle("\(cocktail.id == nil ? "New" : "Update") Cocktail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let id = cocktail.id ?? UUID().uuidString
                        cocktail.id = id
                        bucketList[id] = cocktail
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            onAppear { focus = "Name" }
        }
    }
}

struct IngredientView: View {
    
    @Binding var ingredient: Ingredient
    
    var body: some View {
        VStack {
            HStack {
                TextField("Ingredient", text: $ingredient.name)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                
                TextField("Quantity", value: $ingredient.quantity, formatter: NumberFormatter())
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                
                Picker(ingredient.unit.label, selection: $ingredient.unit) {
                    ForEach(Unit.allCases, id: \.self) { item in
                        Text(item.rawValue)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            Divider()
        }
    }
}
