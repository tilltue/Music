import SwiftUI
import ComposableArchitecture
import MediaPlayer

@main
struct MusicApp: App {
    var body: some Scene {
        WindowGroup {
            AppMainView(
                store: Store(initialState: AppMain.State()) {
                    AppMain()
                }
            )
        }
    }
}
