//
//  MusicPlayer.swift
//  Music
//
//  Created by tilltue on 12/2/24.
//

import Foundation
import ComposableArchitecture
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
    private static let playList = CurrentValueSubject<[MPMediaItem], Never>([])
    
    var musicPlaybackStatus: () -> AnyPublisher<MusicPlayerStatus, Never>?
    var play: () -> Void
    var pause: () -> Void
    var stop: () -> Void
    var setPlayList: ([MPMediaItem]) -> Void
}

extension MusicPlayer: DependencyKey {
    static var liveValue: MusicPlayer {
        let player = MPMusicPlayerController.systemMusicPlayer
        return MusicPlayer(
            musicPlaybackStatus: { [weak player] in player?.statusPublisher },
            play: { [weak player] in player?.play() },
            pause: { [weak player] in player?.pause() },
            stop: { [weak player] in player?.stop() },
            setPlayList: { [weak player] in
                player?.setQueue(with: MPMediaItemCollection(items: $0))
                Self.playList.send($0)
            }
        )
    }
}

private extension MPMusicPlayerController {
    var statusPublisher: AnyPublisher<MusicPlayerStatus, Never> {
        let musicPlayer = MPMusicPlayerController.systemMusicPlayer
        let status: AnyPublisher<MusicPlayerStatus, Never>
        status = NotificationCenter.default.publisher(
            for: Notification.Name.MPMusicPlayerControllerPlaybackStateDidChange,
            object: nil
        )
        .compactMap { [weak musicPlayer] _ in
            MusicPlayerStatus(musicPlayer?.playbackState, song: musicPlayer?.nowPlayingItem)
        }
        .eraseToAnyPublisher()
        
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
