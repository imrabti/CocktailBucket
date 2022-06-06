//
//  EditCocktail.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 16.06.21.
//

import SwiftUI

struct IngredientVO: Codable, Identifiable {
    var id: UUID
    var name: String = ""
    var quantity: Double?
    var unit: Unit = .ml
}

struct StepVO: Codable, Identifiable {
    var id: UUID
    var step: String = ""
}

struct EditCocktail: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var cocktail: Cocktail!
    
    @State private var sourceType = UIImagePickerController.SourceType.camera
    @State private var name = ""
    @State private var withAlcohol = false
    @State private var ingredients: [IngredientVO] = []
    @State private var steps: [StepVO] = []
    @State private var picture: UIImage?
    
    @State private var ingredientsExpanded = true
    @State private var stepsExpanded = true
    @State private var editPicture = false
    
    @FocusState private var focus: String?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Picture")
                        
                        Spacer()
                        
                        Menu {
                            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                Button {
                                    sourceType = .camera
                                    editPicture = true
                                } label: { Label("Camera", systemImage: "camera") }
                            }
                                
                            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                                Button {
                                    sourceType = .photoLibrary
                                    editPicture = true
                                } label: { Label("Photo library", systemImage: "photo.on.rectangle") }
                            }
                        } label: {
                            CocktailPictureView(
                                size: 80,
                                placeholderBackgroundColor: Color(uiColor: .secondarySystemBackground),
                                picture: $picture
                            )
                        }
                    }
                }
                
                Section {
                    TextField("Name", text: $name)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)

                    Toggle("Contain alcohol 🥴", isOn: $withAlcohol)
                }
                
                DisclosureGroup(isExpanded: $ingredientsExpanded) {
                    VStack {
                        List($ingredients) { $ingredient in
                            IngredientView(focus: $focus, ingredient: $ingredient)
                        }
                        Button("Add Ingredient") {
                            let id = UUID()
                            ingredients.append(IngredientVO(id: id))
                            
                            // Workaround delay for the focus to work
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                focus = id.uuidString
                            }
                        }
                    }
                } label: {
                    Text("Ingredients").font(.title3).bold()
                }
                
                DisclosureGroup(isExpanded: $stepsExpanded) {
                    VStack {
                        List($steps) { $step in
                            VStack{
                                TextEditor(text: $step.step)
                                    .focused($focus, equals: step.id.uuidString)
                                Divider()
                            }
                        }
                        Button("Add Step") {
                            let id = UUID()
                            steps.append(StepVO(id: id))
                            
                            // Workaround delay for the focus to work
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                focus = id.uuidString
                            }
                        }
                    }
                } label: {
                    Text("Steps").font(.title3).bold()
                }
            }
            .navigationTitle("\(cocktail.uuid == nil ? "New" : "Update") Cocktail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        viewContext.rollback()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        createOrUpdateCocktail()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear(perform: fetchCocktailData)
            .sheet(isPresented: $editPicture, onDismiss: pictureLoaded) {
                ImagePicker(image: $picture, sourceType: $sourceType)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    private func fetchCocktailData() {
        picture = cocktail.wrappedAttachment?.getImage(with: viewContext)
        name = cocktail.wrappedName
        withAlcohol = cocktail.flags == 1
        
        ingredients = cocktail.wrappedIngredients.map {
            IngredientVO(
                id: $0.uuid!,
                name: $0.wrappedName,
                quantity: $0.quantity,
                unit: $0.unitEnum
            )
        }
        
        steps = cocktail.wrappedSteps.map {
            StepVO(id: $0.uuid!, step: $0.wrappedStep)
        }
    }
    
    private func createOrUpdateCocktail() {
        if cocktail.uuid == nil {
            cocktail.uuid = UUID()
        }
        
        cocktail.name = name
        cocktail.flags = withAlcohol ? 1 : 0
        
        for ingredient in ingredients {
            if let existing = cocktail.wrappedIngredients.first(where: { $0.uuid == ingredient.id }) {
                existing.name = ingredient.name
                existing.unitEnum = ingredient.unit
                existing.quantity = ingredient.quantity ?? 0
            } else {
                let newIngredient = Ingredient(context: viewContext)
                newIngredient.uuid = ingredient.id
                newIngredient.cocktail = cocktail
                newIngredient.name = ingredient.name
                newIngredient.unitEnum = ingredient.unit
                newIngredient.quantity = ingredient.quantity ?? 0
            }
        }
        
        for step in steps {
            if let existing = cocktail.wrappedSteps.first(where: { $0.uuid == step.id} ) {
                existing.step = step.step
            } else {
                let newStep = Step(context: viewContext)
                newStep.uuid = step.id
                newStep.cocktail = cocktail
                newStep.step = step.step
            }
        }
        
        try? viewContext.save()
    }
    
    private func pictureLoaded() {
        print("picture changed ....")
    }
}

struct IngredientView: View {
    
    var focus: FocusState<String?>.Binding
    @Binding var ingredient: IngredientVO
    
    var body: some View {
        VStack {
            HStack {
                TextField("Ingredient", text: $ingredient.name)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .focused(focus, equals: ingredient.id.uuidString)
                
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
