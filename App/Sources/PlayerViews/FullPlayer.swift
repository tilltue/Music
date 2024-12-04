//
//  FullPlayer.swift
//  Music
//
//  Created by tilltue on 12/4/24.
//

import Foundation
import ComposableArchitecture
import MediaPlayer
import Combine

@Reducer
struct FullPlayer {
    @ObservableState
    struct State: Equatable {
        var currentSong: MPMediaItem?
        var isPlaying: Bool = false
        var isShuffle: Bool = false
        var isRepeat: Bool = false
        var progress: Double = 0
    }
    
    enum Action {
        case initial
        case playToggle
        case seekBackword
        case seekForword
        case shuffle
        case `repeat`
        case setProgress(Double)
        case updateProgress(Double)
        case updateCurrentSong(MPMediaItem)
        case updateIsPlaying(Bool)
    }
    
    @Dependency(\.musicPlayer) var musicPlayer
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .initial:
                return .run { await observePlaybackEvents($0) }
            case .playToggle:
                musicPlayer.playToggle()
                return .none
            case .seekBackword:
                musicPlayer.seekBackword()
                return .none
            case .seekForword:
                musicPlayer.seekFoword()
                return .none
            case .shuffle:
                state.isShuffle.toggle()
                musicPlayer.setShuffle(state.isShuffle)
                return .none
            case .repeat:
                state.isRepeat.toggle()
                musicPlayer.setAllRepeat(state.isRepeat)
                return .none
            case .setProgress(let progress):
                musicPlayer.setPlaybackProgress(progress)
                return .none
            case .updateProgress(let progress):
                state.progress = progress
                return .none
            case .updateCurrentSong(let song):
                guard state.currentSong != song else { return .none }
                state.currentSong = song
                return .none
            case .updateIsPlaying(let isPlaying):
                state.isPlaying = isPlaying
                return .none
            }
        }
    }
    
    private func observePlaybackEvents(_ send: Send<Action>) async {
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
}
