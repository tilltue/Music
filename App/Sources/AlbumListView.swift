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
            GeometryReader { geometry in
                ScrollView {
                    let columns = [GridItem(.flexible()), GridItem(.flexible())]
                    LazyVGrid(columns: columns) {
                        ForEach(viewStore.state, id: \.persistentID) { album in
                            Rectangle()
                                .fill(Color.blue)
                                .frame(height: geometry.size.width / 2 - 15)
                                .overlay(Text(album.title ?? "").foregroundColor(.white))
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color.white)
                .task {
                    await store.send(.load).finish()
                }
            }
        }
    }
}
