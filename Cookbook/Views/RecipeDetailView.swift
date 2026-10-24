//
//  RecipeDetailView.swift
//  Cookbook
//
//  Created by Vu Hai Nam Nguyen on 2026-10-18.
//

import SwiftUI

struct RecipeDetailView: View {
	let recipe: Recipe
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 24) {
				// Photo (hero)
				ZStack {
					// chains two check for if the recipe has preview photo
					// and then check if the bytes are an image using decoder
					if let data = recipe.previewPhoto, let uiImage = UIImage(data: data) {
						Image(uiImage: uiImage)
							.resizable()
							.scaledToFill()
							.frame(maxWidth: .infinity)
					} else {
						UnevenRoundedRectangle(
							topLeadingRadius: 12,
							bottomLeadingRadius: 0,
							bottomTrailingRadius: 0,
							topTrailingRadius: 12
						)
						.fill(Color.gray.opacity(0.2))
						
						Image(systemName: "fork.knife")
							.font(.largeTitle)
							.foregroundStyle(.secondary)
					}
				}
				.frame(height: 280)
				.clipped()
				
				VStack(alignment: .leading, spacing: 24) {
					// Title and Summary
					VStack(alignment: .leading, spacing: 8) {
						Text(recipe.name)
							.font(.largeTitle.bold())
						Text(recipe.summary)
							.foregroundStyle(.secondary)
					}
					
					// Ingredients
					VStack(alignment: .leading, spacing: 12) {
						Text("Ingredients")
							.font(.title2.bold())
						
						VStack(alignment: .leading, spacing: 12) {
							ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { _, ingredient in
								IngredientRow(ingredient: ingredient)
							}
						}
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding()
						.background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
					}
					
					// Steps
					VStack(alignment: .leading, spacing: 12) {
						Text("Steps")
							.font(.title2.bold())
						
						VStack(alignment: .leading) {
							ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
								// 2. Divider() removed
								HStack(alignment: .firstTextBaseline) {
									Text("\(index + 1)")
										.font(.headline)
										.frame(width: 24, alignment: .leading)
									Text(step)
								}
								.frame(maxWidth: .infinity, alignment: .leading)
								.padding(.vertical, 10)
								.padding(.horizontal, 12)
								.background(index.isMultiple(of: 2) ? Color(.secondarySystemBackground) : Color.clear)
							}
						}
						.clipShape(RoundedRectangle(cornerRadius: 12))
						
					}
					
				}
				.padding(.horizontal, 28)
			}
		}
		.ignoresSafeArea(edges: .top)
	}
}

#Preview {
	RecipeDetailView(recipe: .sample)
}
