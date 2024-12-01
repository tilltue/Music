//
//  AlbumDetail.swift
//  Music
//
//  Created by tilltue on 12/2/24.
//

import Foundation
import ComposableArchitecture
import MediaPlayer
import Repository

@Reducer
struct AlbumDetail {
    @ObservableState
    struct State: Equatable {
        var album: MPMediaItem
        var songs: [MPMediaItem] = []
    }
    
    enum Action {
        case load
        case setSongs([MPMediaItem])
    }
    
    @Dependency(\.musicRepository) var musicRepository
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .load:
                let songs = musicRepository.fetchSongs(state.album)
                return .send(.setSongs(songs))
            case .setSongs(let songs):
                state.songs = songs
                return .none
            }
        }
    }
}
