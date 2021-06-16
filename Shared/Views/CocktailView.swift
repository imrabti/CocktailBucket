//
//  CocktailView.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 16.06.21.
//

import SwiftUI

struct CocktailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var ingredientsExpanded = true
    @State private var stepsExpanded = true
    
    let cocktail: Cocktail
    
    var body: some View {
        VStack {
            if let pictureUrl = cocktail.picture {
                AsyncImage(url: URL(string: pictureUrl)) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(maxWidth: 200, maxHeight: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    } placeholder: {
                        PicturePlaceHolder()
                    }
            } else {
                PicturePlaceHolder()
            }
            
            List {
                DisclosureGroup(isExpanded: $ingredientsExpanded) {
                    ForEach(cocktail.ingredients) { ingredient in
                        HStack {
                            Text("\(ingredient.unit.format(ingredient.quantity)) - \(ingredient.name)")
                        }
                    }
                } label: {
                    Text("Ingredients").font(.title3).bold()
                }
            
                DisclosureGroup(isExpanded: $stepsExpanded) {
                    ForEach(cocktail.steps) { step in
                        Text(step.markdown)
                    }
                } label: {
                    Text("Steps").font(.title3).bold()
                }
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle(cocktail.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PicturePlaceHolder: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .frame(width: 200, height: 200)
            Image(systemName: "photo")
                .foregroundColor(Color(UIColor.systemGray))
                .font(Font.system(.largeTitle))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

extension Step {
    var markdown: AttributedString {
        try! AttributedString(markdown: value)
    }
}

struct CocktailView_Previews: PreviewProvider {
    static var previews: some View {
        CocktailView(cocktail: Cocktail(name: "Mojito"))
    }
}
