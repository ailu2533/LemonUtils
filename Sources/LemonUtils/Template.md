#  应用模板


```swift

import SwiftData
import SwiftUI

@main
struct MyHabitApp: App {
    var sharedModelContainer: ModelContainer = getModelContainer(isStoredInMemoryOnly: false)

    var vm: HabitViewModel

    var body: some Scene {
        WindowGroup {
            MainView()
        }

                .modelContainer(sharedModelContainer)
                .environment(vm)
    }

    init() {
        vm = HabitViewModel(modelContext: sharedModelContainer.mainContext)
    }
}




@Observable
class HabitViewModel {
    var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    

}




```
