import SwiftUI
import ComposableArchitecture


@main
struct MusicApp: App {
    var body: some Scene {
        WindowGroup {
            AlbumListView(
                store: Store(initialState: AlbumList.State()) {
                    AlbumList()._printChanges()
                }
            )
        }
    }
}
