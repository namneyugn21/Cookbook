import SwiftUI
import SwiftData

struct HomeView: View {
	@Environment(\.modelContext) private var modelContext
	@Query(sort: \Recipe.createdAt, order: .reverse) private var recipes: [Recipe]

	var body: some View {
		NavigationStack {
			Group {
				if recipes.isEmpty {
					ContentUnavailableView("No recipes yet", systemImage: "fork.knife")
				} else {
					ScrollView {
						LazyVStack(spacing: 16) {
							ForEach(recipes) { recipe in
								RecipeCard(recipe: recipe)
							}
						}
						.padding(.horizontal)
						.padding(.vertical)
					}
				}
			}
			.navigationTitle("Cookbook")
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					Button {
						let recipe = Recipe(
							name: "Pancakes",
							summary: "Who wants fluffy pancakes?",
							previewPhoto: UIImage(named: "SoufflePancakes")?.jpegData(compressionQuality: 0.8)
						)
						
						modelContext.insert(recipe)
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
