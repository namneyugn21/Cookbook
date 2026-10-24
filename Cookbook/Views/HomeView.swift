import SwiftUI
import SwiftData

struct HomeView: View {
	@Environment(\.modelContext) private var modelContext
	@Query(sort: \Recipe.createdAt, order: .reverse) private var recipes: [Recipe]
	
	@State private var showingAdd = false

	var body: some View {
		NavigationStack {
			Group {
				if recipes.isEmpty {
					ContentUnavailableView("No recipes yet", systemImage: "fork.knife")
				} else {
					ScrollView {
						LazyVStack(spacing: 16) {
							ForEach(recipes) { recipe in
								NavigationLink {
									RecipeDetailView(recipe: recipe)
								} label: {
									RecipeCard(recipe: recipe)
								}
								.buttonStyle(.plain)
							}
						}
						.padding(.horizontal)
						.padding(.vertical)
					}
				}
			}
			.navigationTitle("Cookbook")
			.sheet(isPresented: $showingAdd) {
				AddRecipeView()
			}
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					Button {
						showingAdd = true
					} label: {
						Image(systemName: "plus")
					}
				}
			}
			.background(Color(.systemGroupedBackground))
		}
	}
}

#Preview {
	HomeView()
		.modelContainer(for: Recipe.self, inMemory: true)
}
