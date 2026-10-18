//
//  Recipe+Sample.swift
//  Cookbook
//
//  Created by Vu Hai Nam Nguyen on 2026-10-18.
//

import Foundation
import SwiftUI

#if DEBUG
extension Recipe {
	static var sample: Recipe {
		Recipe(
			name: "Buttermilk Pancakes",
			summary: "Fluffy, golden pancakes made with love. Great with maple syrup and berries.",
			ingredients: [
				Ingredient(name: "all-purpose flour", quantity: 2, unit: "cups"),
				Ingredient(name: "granulated sugar", quantity: 2, unit: "tbsp"),
				Ingredient(name: "baking powder", quantity: 2, unit: "tsp"),
				Ingredient(name: "baking soda", quantity: 0.5, unit: "tsp"),
				Ingredient(name: "salt", quantity: 0.5, unit: "tsp"),
				Ingredient(name: "buttermilk", quantity: 1.75, unit: "cups"),
				Ingredient(name: "large eggs", quantity: 2, unit: ""),
				Ingredient(name: "unsalted butter, melted", quantity: 4, unit: "tbsp"),
				Ingredient(name: "vanilla extract", quantity: 1, unit: "tsp"),
				Ingredient(name: "butter, for the pan")
			],
			steps: [
				"Whisk the flour, sugar, baking powder, baking soda, and salt in a large bowl.",
				"In a separate bowl, whisk the buttermilk, eggs, melted butter, and vanilla.",
				"Pour the wet ingredients into the dry and stir until just combined. Lumps are fine. Overmixing makes tough pancakes.",
				"Let the batter rest for 5 to 10 minutes so the flour hydrates and the baking powder gets going.",
				"Heat a nonstick pan or griddle over medium heat and rub in a little butter.",
				"Pour about 1/4 cup of batter per pancake. Cook until bubbles form and the edges look set, about 2 to 3 minutes.",
				"Flip and cook another 1 to 2 minutes until golden. Serve warm."
			],
			previewPhoto: UIImage(named: "SoufflePancakes")?.jpegData(compressionQuality: 0.8)
		)
	}
}
#endif
