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
        case play(MPMediaItem)
    }
    
    @Dependency(\.musicRepository) var musicRepository
    @Dependency(\.musicPlayer) var musicPlayer
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .load:
                let songs = musicRepository.fetchSongs(state.album)
                return .send(.setSongs(songs))
            case .setSongs(let songs):
                state.songs = songs
                return .none
            case .play(let song):
                let playList = state.songs.rotated(element: song)
                musicPlayer.setPlayList(playList)
                musicPlayer.play()
                return .none
            }
        }
    }
}

extension Array where Element: Hashable {
    func rotated(element: Element) -> [Element] {
        guard let index = self.firstIndex(of: element) else {
            return self
        }
        let start = self[index...]
        let end = self[..<index]
        return Array(start) + Array(end)
    }
}
