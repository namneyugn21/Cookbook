//
//  Recipe.swift
//  Cookbook
//
//  Created by Vu Hai Nam Nguyen on 2026-10-17.
//

import Foundation
import SwiftData

struct Ingredient: Codable, Hashable, Identifiable {
	var id = UUID()
	var name: String = ""
	var quantity: Double = 0.0
	var unit: String = ""
}

@Model
final class Recipe {
	var name: String
	var summary: String
	var ingredients: [Ingredient]
	var steps: [String]
	var isPublic: Bool
	var createdAt: Date
	var updatedAt: Date
	// store the photo bytes externally on disk
	@Attribute(.externalStorage) var previewPhoto: Data?
	
	init(name: String, summary: String = "", ingredients: [Ingredient], steps: [String], isPublic: Bool = false, previewPhoto: Data? = nil) {
		let now = Date()
		
		self.name = name
		self.summary = summary
		self.ingredients = ingredients
		self.steps = steps
		self.isPublic = isPublic
		self.createdAt = now
		self.updatedAt = now
		self.previewPhoto = previewPhoto
	}
}
