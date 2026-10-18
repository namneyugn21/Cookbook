//
//  Recipe.swift
//  Cookbook
//
//  Created by Vu Hai Nam Nguyen on 2026-10-17.
//

import Foundation
import SwiftData

struct Ingredient: Codable, Hashable {
	var name: String
	var quantity: Double = 0
	var unit: String = ""
}

@Model
final class Recipe {
	var name: String
	var summary: String?
	var ingredients: [Ingredient]
	var steps: [String]
	var isPublic: Bool
	var createdAt: Date
	// store the photo bytes externally on disk
	@Attribute(.externalStorage) var previewPhoto: Data?
	
	init(name: String, summary: String? = nil, ingredients: [Ingredient] = [], steps: [String] = [], isPublic: Bool = false, previewPhoto: Data? = nil) {
		self.name = name
		self.summary = summary
		self.ingredients = ingredients
		self.steps = steps
		self.isPublic = isPublic
		self.createdAt = Date()
		self.previewPhoto = previewPhoto
	}
}
