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
    var quantity: Double = Unit.ml.defaultQuantity
    var unit: Unit = .ml
    var newItem: Bool
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
    @State private var pictureHash: String?
    
    @State private var ingredientsExpanded = true
    @State private var stepsExpanded = true
    @State private var editPicture = false
    
    @FocusState private var focus: String?
    
    private var validForm: Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard !ingredients.isEmpty else { return false }
        guard ingredients.first(where: { $0.name.trimmingCharacters(in: .whitespaces).isEmpty }) == nil else { return false }
        
        return true
    }
    
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
                            
                            if picture != nil {
                                Button {
                                    picture = nil
                                    pictureHash = nil
                                } label: { Label("Delete photo", systemImage: "trash") }
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
                            IngredientView(ingredient: $ingredient, focus: $focus, addIngredient: addIngredient)
                        }
                    }
                } label: {
                    HStack {
                        Text("Ingredients").font(.title3).bold()
                        Spacer()
                        Button(action: addIngredient) {
                            Image(systemName: "plus.app.fill")
                                .imageScale(.large)
                        }
                    }
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
                    }
                } label: {
                    HStack {
                        Text("Steps").font(.title3).bold()
                        Spacer()
                        Button(action: addStep) {
                            Image(systemName: "plus.app.fill")
                                .imageScale(.large)
                        }
                    }
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
                    .disabled(!validForm)
                }
            }
            .onAppear(perform: fetchCocktailData)
            .sheet(isPresented: $editPicture) {
                ImagePicker(image: $picture, pictureHash: $pictureHash, sourceType: $sourceType)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    private func addIngredient() {
        ingredientsExpanded = true
        
        let id = UUID()
        ingredients.append(IngredientVO(id: id, newItem: true))
        
        // Workaround delay for the focus to work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            focus = id.uuidString
        }
    }
    
    private func addStep() {
        stepsExpanded = true
        
        let id = UUID()
        steps.append(StepVO(id: id))
        
        // Workaround delay for the focus to work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            focus = id.uuidString
        }
    }
    
    private func fetchCocktailData() {
        picture = cocktail.wrappedAttachment?.getImage(with: viewContext)
        pictureHash = cocktail.wrappedAttachment?.attachmentHash
        name = cocktail.wrappedName
        withAlcohol = cocktail.flags == 1
        
        ingredients = cocktail.wrappedIngredients.map {
            IngredientVO(
                id: $0.uuid!,
                name: $0.wrappedName,
                quantity: $0.quantity,
                unit: $0.unitEnum,
                newItem: false
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
                existing.quantity = ingredient.quantity
            } else {
                let newIngredient = Ingredient(context: viewContext)
                newIngredient.uuid = ingredient.id
                newIngredient.cocktail = cocktail
                newIngredient.name = ingredient.name
                newIngredient.unitEnum = ingredient.unit
                newIngredient.quantity = ingredient.quantity
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
        
        // Save or update the cocktail picture
        createOrUpdateCocktailPicture()
        
        try? viewContext.save()
        viewContext.reset()
    }
    
    private func createOrUpdateCocktailPicture() {
        // In case the picture is nil check if there was an existing picture
        // this mean that the user have removed the picture for this cocktail
        guard let pictureData = picture?.jpegData(compressionQuality: 1), let pictureHash = pictureHash else {
            guard let existingAttachment = cocktail.wrappedAttachment else { return }
            cocktail.removeFromAttachments(existingAttachment)
            existingAttachment.thumbnail = nil
            viewContext.delete(existingAttachment)
            
            return
        }
        
        // If the pictureHash is still the same then the picture wasn't updated
        guard pictureHash != cocktail.wrappedAttachment?.attachmentHash else { return }
        
        let thumbnailImage = Attachment.thumbnail(from: pictureData, thumbnailPixelSize: 80)
        var attachment: Attachment!
        
        // Update or create
        if let existingAttachment = cocktail.wrappedAttachment {
            attachment = existingAttachment
        } else {
            attachment = Attachment(context: viewContext)
            attachment.uuid = UUID()
            attachment.cocktail = cocktail
        }
        
        attachment.attachmentHash = pictureHash
        attachment.thumbnail = thumbnailImage
        
        // Create or update the ImageData
        if let existingImageData = attachment.imageData {
            existingImageData.data = pictureData
        } else {
            let newImageData = ImageData(context: viewContext)
            newImageData.attachment = attachment
            newImageData.data = pictureData
        }
        
        // Save the full image to the attachment folder and use it as a cache.
        DispatchQueue.global().async {
            var nsError: NSError?
            NSFileCoordinator().coordinate(writingItemAt: attachment.imageURL(), options: .forReplacing, error: &nsError,
                                           byAccessor: { (newURL: URL) -> Void in
                do {
                    try pictureData.write(to: newURL, options: .atomic)
                } catch {
                    print("###\(#function): Failed to save an image file: \(attachment.imageURL())")
                }
            })
            if let nsError = nsError {
                print("###\(#function): \(nsError.localizedDescription)")
            }
        }
    }
}

struct IngredientView: View {
    
    @Binding var ingredient: IngredientVO
    
    var focus: FocusState<String?>.Binding
    var addIngredient: (() -> Void)
    
    var body: some View {
        HStack {
            TextField("Ingredient", text: $ingredient.name)
                .autocapitalization(.words)
                .disableAutocorrection(true)
                .focused(focus, equals: ingredient.id.uuidString)
                
            TextField("Quantity", value: $ingredient.quantity, formatter: NumberFormatter())
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .onSubmit(addIngredient)
                
            Picker(ingredient.unit.label, selection: $ingredient.unit) {
                ForEach(Unit.allCases, id: \.self) { item in
                    Text(item.rawValue)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .onChange(of: ingredient.unit) { newUnit in
            guard ingredient.newItem else { return }
            ingredient.quantity = newUnit.defaultQuantity
        }
        
        Divider()
    }
}
