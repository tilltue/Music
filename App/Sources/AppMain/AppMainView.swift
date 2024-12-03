//
//  AppMainView.swift
//  Music
//
//  Created by tilltue on 12/3/24.
//

import SwiftUI
import ComposableArchitecture

struct AppMainView: View {
    let store: StoreOf<AppMain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                AlbumListView(
                    store: Store(initialState: AlbumList.State()) {
                        AlbumList()
                    }
                )
                MiniPlayerView(
                    store: Store(initialState: MiniPlayer.State()) {
                        MiniPlayer()
                    }
                )
                .safeAreaPadding(.bottom)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
            }
        }
    }
}
