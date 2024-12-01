//
//  AlbumListView.swift
//  Music
//
//  Created by tilltue on 12/1/24.
//

import SwiftUI
import ComposableArchitecture
import MediaPlayer

struct AlbumListView: View {
    let store: StoreOf<AlbumList>
    
    var body: some View {
        WithViewStore(store, observe: { $0.albums }) { viewStore in
            NavigationStack {
                GeometryReader { geometry in
                    ScrollView {
                        let columns = [GridItem(.flexible()), GridItem(.flexible())]
                        LazyVGrid(columns: columns) {
                            ForEach(viewStore.state, id: \.persistentID) { album in
                                NavigationLink(destination: AlbumDetailView(album: album)) {
                                    AlbumGridItem(album: album)
                                        .frame(height: geometry.size.width / 2 - 15)
                                }
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.black)
                    .task {
                        await store.send(.load).finish()
                    }
                }
                .navigationTitle("Albums")
            }
        }
    }
}

struct AlbumGridItem: View {
    let album: MPMediaItem
    
    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .overlay(Text(album.albumTitle ?? "").foregroundColor(.white))
    }
}
