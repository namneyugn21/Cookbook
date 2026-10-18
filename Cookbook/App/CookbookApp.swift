import SwiftUI
import SwiftData

@main struct CookbookApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
		.modelContainer(for: Recipe.self)
    }
}
