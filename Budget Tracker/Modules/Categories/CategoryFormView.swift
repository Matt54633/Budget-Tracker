//
//  CategoryFormView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import SwiftUI
import SwiftData
import WidgetKit

struct CategoryFormView: View {
    @Query private var transactions: [Transaction]
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State var categoryTitle: String = ""
    @State var selectedColor: Color = .blue
    @State private var showAlert = false
    @FocusState private var isTitleFieldFocused: Bool
    let category: Category?
    let colors: [Color] = [.blue, .green, .red, .yellow, .orange, .purple, .pink, .gray, .brown, .indigo, .cyan, .mint]
    var editFlag: Bool = true
    
    var body: some View {
        NavigationStack {
            List {
                
                TextField("Title", text: $categoryTitle)
                    .fontWeight(.semibold)
                    .font(.title3)
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                    .onAppear {
                        if !editFlag {
                            isTitleFieldFocused = true
                        }
                    }
                    .focused($isTitleFieldFocused)
                    .disabled(categoryTitle == "Apple Pay")
                
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                    ForEach(colors, id: \.self) { color in
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(color)
                            .frame(width: 46, height: 46)
                            .onTapGesture {
                                selectedColor = color
                            }
                            .overlay(selectedColor == color ? Image(systemName: "checkmark") : nil)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .disabled(categoryTitle == "Apple Pay")
            }
            .padding(.top, -20)
            .overlay(alignment: .bottom) {
                HStack(spacing: 10) {
                    
                    if editFlag {
                        Button {
                            showAlert = true
                        } label: {
                            Text("Delete")
                                .padding(7.5)
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(categoryTitle == "Apple Pay")
                        .fontWeight(.semibold)
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Warning"),
                                message: Text("All transactions for this category will also be deleted. Are you sure you want to continue?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    if let category = category {
                                        let transactionsToDelete = transactions.filter { $0.category == category }
                                        for transaction in transactionsToDelete {
                                            context.delete(transaction)
                                        }
                                        
                                        context.delete(category)
                                    }
                                    
                                    dismiss()
                                    WidgetCenter.shared.reloadAllTimelines()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                    
                    Button {
                        if let category = category {
                            category.title = categoryTitle
                            category.color = selectedColor.description
                        } else {
                            let category = Category(title: categoryTitle, color: selectedColor.description)
                            
                            context.insert(category)
                        }
                        
                        dismiss()
                        WidgetCenter.shared.reloadAllTimelines()
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding(7.5)
                    }
                    .fontWeight(.semibold)
                    .disabled(categoryTitle.isEmpty || categoryTitle == "Apple Pay")
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
            }
            .listRowSpacing(12)
        }
    }
}

#Preview {
    CategoryFormView(category: nil, editFlag: true)
}
