//
//  MiniPlayer.swift
//  Music
//
//  Created by tilltue on 12/3/24.
//

import Foundation
import ComposableArchitecture
import MediaPlayer
import Combine

@Reducer
struct MiniPlayer {
    @ObservableState
    struct State: Equatable {
        var currentSong: MPMediaItem?
        var isPlaying: Bool = false
        var progress: Double = 0.5
    }
    
    enum Action {
        case initial
        case play
        case pause
        case updateProgress(Double)
        case updateCurrentSong(MPMediaItem)
        case updateIsPlaying(Bool)
    }
    
    @Dependency(\.musicPlayer) var musicPlayer
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .initial:
                return .run { send in
                    guard let playerStatusStream = musicPlayer.musicPlaybackStatus() else { return }
                    for try await playerStatus in playerStatusStream.values {
                        switch playerStatus {
                        case .playing(let song):
                            await send(.updateIsPlaying(true))
                            if let song {
                                await send(.updateCurrentSong(song))
                            }
                        case .paused(let song), .stopped(let song):
                            await send(.updateIsPlaying(false))
                            if let song {
                                await send(.updateCurrentSong(song))
                            }
                        case .songChanged(let song):
                            await send(.updateCurrentSong(song))
                        case .progress(let song, let progress):
                            await send(.updateCurrentSong(song))
                            await send(.updateProgress(progress))
                        }
                    }
                }
            case .play:
                musicPlayer.play()
                return .none
            case .pause:
                musicPlayer.pause()
                return .none
            case .updateProgress(let progress):
                state.progress = progress
                return .none
            case .updateCurrentSong(let song):
                state.currentSong = song
                return .none
            case .updateIsPlaying(let isPlaying):
                state.isPlaying = isPlaying
                return .none
            }
        }
    }
}