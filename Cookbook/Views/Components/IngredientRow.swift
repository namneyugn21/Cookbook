//
//  IngredientRow.swift
//  Cookbook
//
//  Created by Vu Hai Nam Nguyen on 2026-10-18.
//

import SwiftUI

struct IngredientRow: View {
	let ingredient: Ingredient
	
	private var quantityText: String {
		var text = ingredient.quantity.formatted()
		if !ingredient.unit.isEmpty {
			text += " " + ingredient.unit
		}
		return text
	}
	
	var body: some View {
		HStack(alignment: .firstTextBaseline) {
			Text(quantityText)
				.frame(width: 80, alignment: .leading)
			Text(ingredient.name)
		}
	}
}

#Preview {
	IngredientRow(ingredient: Ingredient(
		name: "Buttermilk",
		quantity: 2,
		unit: "cups"
	))
}
