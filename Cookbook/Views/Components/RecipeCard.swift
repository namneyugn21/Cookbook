//
//  RecipeCard.swift
//  Cookbook
//
//  Created by Vu Hai Nam Nguyen on 2026-10-18.
//

import SwiftUI

struct RecipeCard: View {
	let recipe: Recipe
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
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
			.frame(height: 200)
			.clipped()
			
			VStack(alignment: .leading, spacing: 4) {
				Text(recipe.name)
					.font(.headline)
					.lineLimit(1)
				
				Text(recipe.summary)
					.font(.subheadline)
				
				Text(recipe.createdAt, style: .date)
					.font(.footnote)
					.frame(maxWidth: .infinity, alignment: .trailing)
					.foregroundStyle(.secondary)
			}
			.padding(.horizontal)
			.padding(.vertical)
		}
		.background(Color(.secondarySystemGroupedBackground))
		.clipShape(RoundedRectangle(cornerRadius: 12))
	}
}

#Preview {
	RecipeCard(recipe: .sample)
}
