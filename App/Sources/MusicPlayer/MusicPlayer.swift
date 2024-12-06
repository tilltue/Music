//
//  MusicPlayer.swift
//  Music
//
//  Created by tilltue on 12/2/24.
//

import Foundation
import ComposableArchitecture
import Repository
import MediaPlayer
import Combine

enum MusicPlayerStatus {
    case playing(MPMediaItem?)
    case paused(MPMediaItem?)
    case stopped(MPMediaItem?)
    case songChanged(MPMediaItem)
    case progress(MPMediaItem, Double)
}

struct MusicPlayer {
    var musicPlaybackStatus: () -> AnyPublisher<MusicPlayerStatus, Never>?
    var playToggle: () -> Void
    var setPlayList: ([Song]) -> Void
    var setPlaybackProgress: (Double) -> Void
    var setAllRepeat: (Bool) -> Void
    var setShuffle: (Bool) -> Void
    var seekBackword: () -> Void
    var seekFoword: () -> Void
}

extension MusicPlayer: DependencyKey {
    static var liveValue: MusicPlayer {
        let player = MPMusicPlayerController.systemMusicPlayer
        return MusicPlayer(
            musicPlaybackStatus: { [weak player] in player?.statusPublisher },
            playToggle: { [weak player] in
                player?.playbackState == .playing ? player?.pause() : player?.play()
            },
            setPlayList: { [weak player] songs in
                let query = MPMediaQuery.songs()
                guard let items = query.items else { return }
                let dict = Dictionary(uniqueKeysWithValues: items.map {
                    ($0.persistentID, $0)
                })
                let songItems = songs.compactMap { dict[$0.songId] }
                player?.setQueue(with:MPMediaItemCollection(items: songItems))
                player?.prepareToPlay { [weak player] in
                    guard $0 == nil else { return }
                    player?.play()
                }
            },
            setPlaybackProgress: { [weak player] progress in
                guard let nowPlayingDuration = player?.nowPlayingItem?.playbackDuration else { return }
                player?.currentPlaybackTime = nowPlayingDuration * progress
            },
            setAllRepeat: { [weak player] allRepeat in
                player?.repeatMode = allRepeat ? .all : .none
            },
            setShuffle: { [weak player] shuffle in
                player?.shuffleMode = shuffle ? .songs : .off
            },
            seekBackword: { [weak player] in
                player?.skipToPreviousItem()
            },
            seekFoword: { [weak player] in
                player?.skipToNextItem()
            }
        )
    }
}

private extension MPMusicPlayerController {
    var statusPublisher: AnyPublisher<MusicPlayerStatus, Never> {
        let musicPlayer = MPMusicPlayerController.systemMusicPlayer
        var status: AnyPublisher<MusicPlayerStatus, Never>
        status = NotificationCenter.default.publisher(
            for: Notification.Name.MPMusicPlayerControllerPlaybackStateDidChange,
            object: nil
        )
        .compactMap { [weak musicPlayer] _ in
            MusicPlayerStatus(musicPlayer?.playbackState, song: musicPlayer?.nowPlayingItem)
        }
        .eraseToAnyPublisher()
        
        if
            let nowPlayingSong = musicPlayer.nowPlayingItem,
            let playingStatus = MusicPlayerStatus(musicPlayer.playbackState, song: nowPlayingSong)
        {
            status = status.prepend(playingStatus)
                .eraseToAnyPublisher()
        }
        
        let songChanged: AnyPublisher<MusicPlayerStatus, Never>
        songChanged = NotificationCenter.default.publisher(
            for: Notification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
            object: nil
        )
        .compactMap { [weak musicPlayer] _ in musicPlayer?.nowPlayingItem }
        .map { .songChanged($0) }
        .eraseToAnyPublisher()
        
        let progress: AnyPublisher<MusicPlayerStatus, Never>
        progress = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
            .compactMap { [weak musicPlayer] _ in musicPlayer?.nowPlayingItem }
            .filter { [weak musicPlayer] _ in musicPlayer?.playbackState == .playing }
            .map { item in
                let progress = Double(musicPlayer.currentPlaybackTime / item.playbackDuration)
                return .progress(item, progress)
            }
            .eraseToAnyPublisher()

        return status
            .merge(with: songChanged)
            .merge(with: progress)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension DependencyValues {
    var musicPlayer: MusicPlayer {
        get { self[MusicPlayer.self] }
        set { self[MusicPlayer.self] = newValue }
    }
}

private extension MusicPlayerStatus {
    init?(_ status: MPMusicPlaybackState?, song: MPMediaItem?) {
        guard let status = status else { return nil }
        switch status {
        case .playing:
            self = .playing(song)
        case .paused:
            self = .paused(song)
        case .stopped, .interrupted:
            self = .stopped(song)
        default:
            return nil
        }
    }
}
