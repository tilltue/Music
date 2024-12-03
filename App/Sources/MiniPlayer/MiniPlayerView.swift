//
//  MiniPlayerView.swift
//  Music
//
//  Created by tilltue on 12/2/24.
//

import SwiftUI
import ComposableArchitecture
import MediaPlayer

struct MiniPlayerView: View {
    let store: StoreOf<MiniPlayer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore  in
            ZStack(alignment: .leading) {
                HStack {
                    AlbumImage(width: 30, cornerRadius: 3, albumImage: nil)
                        .padding(.leading, 5)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(viewStore.currentSong?.title ?? "")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                        Text(viewStore.currentSong?.artist ?? "")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                    Button(action: {
                        store.send(viewStore.isPlaying ? .pause : .play)
                    }) {
                        Image(systemName: viewStore.isPlaying ? "pause.fill" : "play.fill")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 15)
                }
                VStack {
                    Spacer()
                    ProgressView(value: viewStore.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .white))
                        .frame(height: 1)
                        .padding(.horizontal, 5)
                }
            }
            .frame(height: 50)
            .background(Color(hex: "#2c7972"))
            .cornerRadius(5)
            .task {
                await store.send(.initial).finish()
            }
        }
    }
}

//#Preview {
//    ZStack {
//        Rectangle()
//            .foregroundColor(.black)
//        MiniPlayerView()
//    }
//    .ignoresSafeArea()
//}
