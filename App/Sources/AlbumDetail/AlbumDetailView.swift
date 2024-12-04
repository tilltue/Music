//
//  AlbumDetailView.swift
//  Music
//
//  Created by tilltue on 12/2/24.
//

import SwiftUI
import ComposableArchitecture
import MediaPlayer

struct AlbumDetailView: View {
    let store: StoreOf<AlbumDetail>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { geometry in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        let width = geometry.size.width * (7/10)
                        VStack(spacing: 2) {
                            AlbumDetailHeader(width: width, album: viewStore.album)
                                .padding(.horizontal, 20)
                            MusicButtonsView(
                                playTap: { store.send(.play(nil)) },
                                shuffleTap: { store.send(.shufflePlay) }
                            )
                        }
                        Divider()
                        let songs = viewStore.songs
                        ForEach(Array(zip(songs.indices, songs)), id: \.1.persistentID) { index, song in
                            HStack(spacing: 5) {
                                Text("\(index + 1)")
                                    .foregroundColor(.gray)
                                    .frame(width: 20, alignment: .leading)
                                Text(song.title ?? "")
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 40)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                store.send(.play(song))
                            }
                            
                            if index < songs.count - 1 {
                                Divider().padding(.leading, 40)
                            }
                        }
                        Divider()
                    }
                    
                }
                .background(Color.black)
                .task {
                    await store.send(.load).finish()
                }
                .toolbarRole(.editor)
            }
        }
    }
}

private struct AlbumDetailHeader: View {
    let width: CGFloat
    let album: MPMediaItem
    
    var body: some View {
        return VStack(spacing: 2) {
            let albumImage = album.artwork?.image(at: .init(width: width, height: width))
            AlbumImage(width: width, albumImage: albumImage)
                .applyThumbnail(width: width)
                .padding(.bottom, 10)
            Text(album.albumTitle ?? "")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 20)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
            Text(album.albumArtist ?? "")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 20)
                .font(.system(size: 20))
                .foregroundColor(.gray)
            Text(album.genre ?? "")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 20)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct MusicButtonsView: View {
    var playTap: () -> Void
    var shuffleTap: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            MusicButton(
                title: "재생",
                iconName: "play.fill"
            ).onTapGesture{ _ in playTap() }
            
            MusicButton(
                title: "임의 재생",
                iconName: "shuffle"
            ).onTapGesture{ _ in shuffleTap() }
        }
        .padding()
    }
    
    struct MusicButton: View {
        let title: String
        let iconName: String
        
        var body: some View {
            HStack {
                Image(systemName: iconName)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.red)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.red)
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .padding(.horizontal, 20)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(15)
        }
    }
}
