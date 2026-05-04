//
//  CategoryListItemView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import SwiftUI

struct CategoryListItemView: View {
    var category: Category
    
    var body: some View {
        NavigationLink {
            CategoryFormView(categoryTitle: category.title,  selectedColor: customColorMappings[category.color] ?? .blue, category: category, editFlag: true)        } label: {
                HStack {
                    Rectangle()
                        .fill(customColorMappings[category.color] ?? .blue)
                        .frame(width: 10)
                    
                    Text(category.title)
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .padding(.leading, 7.5)
                }
            }
    }
}

#Preview {
    CategoryListItemView(category: Category(title: "Groceries", color: "blue"))
}
