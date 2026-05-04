//
//  CategoriesView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import SwiftUI
import SwiftData

struct CategoriesView: View {
    @Query private var categories: [Category]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            VStack {
                if categories.count > 0 {
                    CategoryList()
                } else {
                    ContentUnavailableView("No Categories", systemImage: "folder")
                        .padding(.top, -20)
                }
            }
   
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink {
                        CategoryFormView(category: nil, editFlag: false)
                    } label: {
                        CreateButton()
                    }
                    .padding(.top)
                }

            }
            .background(Rectangle().fill(.listBackground).ignoresSafeArea())
            .toolbar {
                
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        
                    } label: {
                        Text("Categories")
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .font(.subheadline)
                            .frame(minWidth: 95)
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .tint(.listItemBackground)
                }
            }

        }
    }
}

#Preview {
    CategoriesView()
}
