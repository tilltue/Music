//
//  AppMainView.swift
//  Music
//
//  Created by tilltue on 12/3/24.
//

import SwiftUI
import ComposableArchitecture

struct AppMainView: View {
    @State private var isExpanded = false
    @Namespace private var animation
    
    let store: StoreOf<AppMain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    AlbumListView(
                        store: Store(initialState: AlbumList.State()) {
                            AlbumList()
                        }
                    )
                    MiniPlayerView(
                        store: Store(initialState: MiniPlayer.State()) {
                            MiniPlayer()
                        },
                        animation: animation
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .safeAreaPadding(.bottom, 10)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isExpanded = true
                        }
                    }
                }
                .sheet(isPresented: $isExpanded) {
                    fullPlayerView
                }
            }.task {
                await store.fullPlayerStore.send(.initial).finish()
            }
        }
    }
    
    private var fullPlayerView: some View {
        FullPlayerView(
            store: store.fullPlayerStore,
            animation: animation
        )
    }
}
