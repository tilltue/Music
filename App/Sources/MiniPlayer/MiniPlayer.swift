//
//  MiniPlayer.swift
//  Music
//
//  Created by tilltue on 12/3/24.
//

import Foundation
import ComposableArchitecture
import MediaPlayer

@Reducer
struct MiniPlayer {
    @ObservableState
    struct State: Equatable {
        var song: MPMediaItem?
        var isPlaying: Bool = false
        var progress: Double = 0.5
    }
    
    enum Action {
        case initiali(MPMediaItem?)
        case play
        case pause
        case updateProgress(Double)
    }
    
    @Dependency(\.musicPlayer) var musicPlayer
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            let musicPlayer = MPMusicPlayerController.systemMusicPlayer
            switch action {
            case .initiali(let song):
                if let song {
                    state.song = song
                    return .none
                } else {
                    state.song = musicPlayer.nowPlayingItem
                    return .none
                }
            case .play:
                state.isPlaying = true
                guard let song = state.song else { return .none }
                return .run { [weak musicPlayer] send in
                    musicPlayer?.setQueue(with: MPMediaItemCollection(items: [song]))
                    musicPlayer?.play()
                }
            case .pause:
                state.isPlaying = false
                return .run { [weak musicPlayer] send in
                    musicPlayer?.pause()
                }
            case .updateProgress(let progress):
                state.progress = progress
                return .none
            }
        }
    }
}
