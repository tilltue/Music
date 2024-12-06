//
//  AlbumDetail.swift
//  Music
//
//  Created by tilltue on 12/2/24.
//

import Foundation
import ComposableArchitecture
import Repository

@Reducer
struct AlbumDetail {
    @ObservableState
    struct State: Equatable {
        var album: MusicAlbum
        var songs: [Song] = []
    }
    
    enum Action {
        case load
        case setSongs([Song])
        case play(Song?)
        case shufflePlay
    }
    
    @Dependency(\.musicRepository) var musicRepository
    @Dependency(\.musicPlayer) var musicPlayer
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .load:
                let songs = musicRepository.fetchSongs(state.album.albumId)
                return .send(.setSongs(songs))
            case .setSongs(let songs):
                state.songs = songs
                return .none
            case .play(let song):
                if let song {
                    play(state.songs.rotated(element: song))
                } else {
                    play(state.songs)
                }
                return .none
            case .shufflePlay:
                play(state.songs.shuffled())
                return .none
            }
        }
    }
    
    private func play(_ playList: [Song]) {
        musicPlayer.setPlayList(playList)
    }
}

private extension Array where Element: Hashable {
    func rotated(element: Element) -> [Element] {
        guard let index = self.firstIndex(of: element) else {
            return self
        }
        let start = self[index...]
        let end = self[..<index]
        return Array(start) + Array(end)
    }
}
