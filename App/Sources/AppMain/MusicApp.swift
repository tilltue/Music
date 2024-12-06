import SwiftUI
import ComposableArchitecture

@main
struct MusicApp: App {
    var body: some Scene {
        WindowGroup {
//            EmptyView()
            AppMainView(
                store: Store(initialState: AppMain.State()) {
                    AppMain()
                }
            )
        }
    }
}
