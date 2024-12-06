//
//  AlbumListView.swift
//  Music
//
//  Created by tilltue on 12/1/24.
//

import SwiftUI
import ComposableArchitecture

struct AlbumListView: View {
    let store: StoreOf<AlbumList>
    
    var body: some View {
        WithViewStore(store, observe: { $0.albums }) { viewStore in
            NavigationStack {
                GeometryReader { geometry in
                    ScrollView {
                        let columns = [GridItem(.flexible()), GridItem(.flexible())]
                        LazyVGrid(columns: columns) {
                            ForEach(viewStore.state, id: \.albumId) { album in
                                let destination = AlbumDetailView(
                                    store: Store(initialState: AlbumDetail.State(album: album)) {
                                        AlbumDetail()
                                    }
                                )
                                NavigationLink(destination:destination) {
                                    AlbumGridItem(album: album)
                                        .frame(height: geometry.size.width / 2 + 20)
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
                .navigationBarItems(leading: Text("Albums").foregroundColor(.white))
                .toolbarBackground(Color.black, for: .navigationBar)
            }
        }
    }
}
