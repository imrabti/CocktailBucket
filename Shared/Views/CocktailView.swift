//
//  CocktailView.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 16.06.21.
//

import SwiftUI

struct CocktailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var ingredientsExpanded = true
    @State private var stepsExpanded = true
    @State private var picture: UIImage?
    
    let cocktail: Cocktail
    
    var body: some View {
        VStack {
            CocktailPictureView(size: 200, placeholderBackgroundColor: .white, picture: $picture)
            
            List {
                DisclosureGroup(isExpanded: $ingredientsExpanded) {
                    ForEach(cocktail.wrappedIngredients) { ingredient in
                        HStack {
                            Text("\(ingredient.unitEnum.format(ingredient.quantity)) - \(ingredient.wrappedName)")
                        }
                    }
                } label: {
                    Text("Ingredients").font(.title3).bold()
                }
            
                if !cocktail.wrappedSteps.isEmpty {
                    DisclosureGroup(isExpanded: $stepsExpanded) {
                        ForEach(cocktail.wrappedSteps) { step in
                            Text(step.markdown)
                        }
                    } label: {
                        Text("Steps").font(.title3).bold()
                    }
                }
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle(cocktail.wrappedName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { picture = cocktail.wrappedAttachment?.getImage(with: viewContext) }
    }
}

struct CocktailPictureView: View {
    
    // MARK : - Properties
    
    let size: CGFloat
    let placeholderBackgroundColor: Color
    
    @Binding var picture: UIImage?
    
    var body: some View {
        if let picture = picture {
            Image(uiImage: picture)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(placeholderBackgroundColor)
                    .frame(width: size + 2, height: size + 2)

                if size >= 200 {
                    Image(systemName: "photo")
                        .foregroundColor(Color(UIColor.systemGray))
                        .font(Font.system(.largeTitle))
                } else {
                    Image(systemName: "photo")
                        .foregroundColor(Color(UIColor.systemGray))
                        .imageScale(.medium)
                }
            }
        }
    }
}

extension Step {
    var markdown: AttributedString {
        try! AttributedString(markdown: wrappedStep)
    }
}
