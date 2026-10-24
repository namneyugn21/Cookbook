//
//  AddRecipeView.swift
//  Cookbook
//
//  Created by Vu Hai Nam Nguyen on 2026-10-18.
//

import SwiftUI
import PhotosUI
import SwiftData

private struct DraftStep: Identifiable {
	let id = UUID()
	var text: String = ""
}

private extension String {
	var trimmed: String {
		trimmingCharacters(in: .whitespacesAndNewlines)
	}
}

struct AddRecipeView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext

	@State private var name: String = ""
	@State private var summary: String = ""
	@State private var ingredients: [Ingredient] = []
	@State private var steps: [DraftStep] = []
	@State private var isPublic: Bool = false
	
	// states to store the photo actions
	@State private var photoData: Data? // actual bytes of the photo
	@State private var showSourceDialog = false
	@State private var showLibrary = false
	@State private var selectedItem: PhotosPickerItem? // store the reference of the selected item in the photo library
	@State private var showCamera = false
	@State private var capturedImage: UIImage?

	/**
	 The function will make sure the name, ingredients, and steps are not empty
	 For ingredients, there need to be at least 1 ingredients with all fields filled
	 For steps, there also need to be at least 1 step and not an empty string
	 */
	private var canSave: Bool {
		let hasName = !name.trimmed.isEmpty
		
		let hasIngredients = !ingredients.isEmpty &&
		ingredients.allSatisfy { ingredient in
			!ingredient.name.trimmed.isEmpty &&
			!ingredient.unit.trimmed.isEmpty
		}
		
		let hasSteps = !steps.isEmpty &&
		steps.allSatisfy { step in
			!step.text.trimmed.isEmpty
		}
		
		return hasName && hasIngredients && hasSteps
	}
	
	/**
	 Make sure the current ingredient is filled out first before adding the next
	 */
	private func isComplete(_ ingredient: Ingredient) -> Bool {
		!ingredient.name.trimmed.isEmpty &&
		!ingredient.unit.trimmed.isEmpty
	}
	private var canAddIngredient: Bool {
		ingredients.allSatisfy(isComplete)
	}
	
	/**
	 Make sure the current step is filled out first before adding the next
	 */
	private var canAddStep: Bool {
		steps.allSatisfy { !$0.text.trimmed.isEmpty }
	}

	var body: some View {
		NavigationStack {
			Form {
				// Preview photo
				Section {
					Button {
						showSourceDialog = true
					} label: {
						Color.clear
							.aspectRatio(1, contentMode: .fit)
							.overlay {
								if let photoData, let uiImage = UIImage(data: photoData) {
									Image(uiImage: uiImage)
										.resizable()
										.scaledToFill()
								} else {
									ZStack {
										RoundedRectangle(cornerRadius: 16)
											.fill(Color.accentColor.opacity(0.1))
										VStack(spacing: 8) {
											Image(systemName: "camera.fill")
												.font(.title)
											Text("Add photo")
												.font(.subheadline)
										}
										.foregroundStyle(Color.accentColor)
									}
								}
							}
							.clipShape(RoundedRectangle(cornerRadius: 16))
					}
					.buttonStyle(.plain)
				}
				.listRowInsets(EdgeInsets())
				.listRowBackground(Color.clear)
				.padding(.top)

				// Basic info
				Section("What's it?") {
					TextField("Recipe name", text: $name)
						.textInputAutocapitalization(.words)
					TextField("Summary", text: $summary, axis: .vertical)
						.lineLimit(2...4)
				}

				// Ingredients
				Section("What's in it?") {
					ForEach($ingredients) { $ingredient in
						Grid(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 8) {
							// Top row: name spans both columns
							GridRow {
								TextField("Ingredient", text: $ingredient.name)
									.gridCellColumns(2)
							}

							// Bottom row: qty (left), unit (right)
							GridRow {
								TextField("Qty", value: $ingredient.quantity, format: .number)
									.keyboardType(.decimalPad)
									.multilineTextAlignment(.leading)
									.padding(.horizontal, 10)
									.padding(.vertical, 6)
									.background(Color(.secondarySystemFill), in: RoundedRectangle(cornerRadius: 8))

								TextField("Unit (g, cup...)", text: $ingredient.unit)
									.textInputAutocapitalization(.never)
									.padding(.horizontal, 10)
									.padding(.vertical, 6)
									.background(Color(.secondarySystemFill), in: RoundedRectangle(cornerRadius: 8))
							}
							.font(.subheadline)
						}
						.padding(.vertical, 4)
						.swipeActions {
							Button(role: .destructive) {
								ingredients.removeAll { $0.id == ingredient.id }
							} label: { Label("Delete", systemImage: "trash") }
						}
					}

					Button {
						ingredients.append(Ingredient())
					} label: {
						Label("Add ingredient", systemImage: "plus.circle.fill")
					}
					.disabled(!canAddIngredient)
				}
				
				// Steps
				Section("How can you make it?") {
					ForEach($steps) { $step in
						let number = (steps.firstIndex { $0.id == step.id } ?? 0) + 1

						HStack(alignment: .top, spacing: 12) {
							Text("\(number)")
								.font(.caption.bold())
								.foregroundStyle(Color.accentColor)
								.frame(width: 24, height: 24)
								.background(Color.accentColor.opacity(0.15), in: Circle())
							TextField("Describe this step", text: $step.text, axis: .vertical)
						}
						.swipeActions {
							Button(role: .destructive) {
								steps.removeAll { $0.id == step.id }
							} label: { Label("Delete", systemImage: "trash") }
						}
					}

					Button {
						steps.append(DraftStep())
					} label: {
						Label("Add step", systemImage: "plus.circle.fill")
					}
					.disabled(!canAddStep)
				}

				// Public/Private
				Section {
					Toggle("Make public", isOn: $isPublic)
				} footer: {
					Text("Anyone can view public recipes. Private ones stay on your device.")
				}
			}
			.scrollDismissesKeyboard(.interactively)
			.confirmationDialog("Recipe photo", isPresented: $showSourceDialog) {
				// Check if the device have a camera
				if UIImagePickerController.isSourceTypeAvailable(.camera) {
					Button("Take Photo") { showCamera = true }
				}
				
				// Option to select photo from library
				Button("Choose from Library") { showLibrary = true }
				
				// Option to clear the current photo
				if photoData != nil {
					Button("Remove Photo", role: .destructive) {
						photoData = nil
						selectedItem = nil
					}
				}
			}
			.photosPicker(isPresented: $showLibrary, selection: $selectedItem, matching: .images)
			.fullScreenCover(isPresented: $showCamera) {
				CameraPicker(image: $capturedImage)
					.ignoresSafeArea()
			}
			.onChange(of: selectedItem) { _, newItem in
				Task {
					guard let data = try? await newItem?.loadTransferable(type: Data.self),
						  let image = UIImage(data: data) else { return }
					photoData = image.squareJPEGData()
				}
			}
			.onChange(of: capturedImage) { _, newImage in
				guard let newImage else { return }
				photoData = newImage.squareJPEGData()
				capturedImage = nil
			}
			.navigationTitle("New Recipe")
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("Cancel") {
						dismiss()
					}
				}
				ToolbarItem(placement: .confirmationAction) {
					Button("Save") {
						save()
					}
					.disabled(!canSave)
				}
			}
		}
	}

	private func save() {
		let trimmedSummary = summary.trimmed
		
		let cleanedIngredients = ingredients
			.map { ingredient in
				var copy = ingredient
				copy.name = ingredient.name.trimmed
				copy.unit = ingredient.unit.trimmed
				return copy
			}
			.filter { !$0.name.isEmpty }

		let cleanedSteps = steps
			.map { $0.text.trimmed }
			.filter { !$0.isEmpty }
				
		let recipe = Recipe(
			name: name.trimmed,
			summary: trimmedSummary.isEmpty ? "" : trimmedSummary,
			ingredients: cleanedIngredients,
			steps: cleanedSteps,
			isPublic: isPublic,
			previewPhoto: photoData
		)
		
		modelContext.insert(recipe)
		dismiss()
	}
}

#Preview {
	AddRecipeView()
		.modelContainer(for: Recipe.self, inMemory: true)
}
