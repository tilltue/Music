//
//  Repository.swift
//  RepositoryTests
//
//  Created by tilltue on 11/30/24.
//

import Foundation
import ComposableArchitecture
import MediaPlayer

public struct MusicRepository {
    public var authorizationStatus: () -> MPMediaLibraryAuthorizationStatus
    public var requestAuthorization: () async -> MPMediaLibraryAuthorizationStatus
    public var fetchAlbums: () -> [MusicAlbum]
    public var fetchSongs: (UInt64) -> [Song]
}

extension MusicRepository: DependencyKey {
    public static let liveValue = Self(
        authorizationStatus: { MPMediaLibrary.authorizationStatus() },
        requestAuthorization: { await MPMediaLibrary.requestAuthorization() },
        fetchAlbums: {
            let albumsQuery = MPMediaQuery.albums()
            let albums = albumsQuery.collections?
                .compactMap { $0.representativeItem }
                .map(MusicAlbum.init(album:))
            return albums ?? []
        },
        fetchSongs: {
            let songsQuery = MPMediaQuery.songs()
            let predicate = MPMediaPropertyPredicate(
                value: $0,
                forProperty: MPMediaItemPropertyAlbumPersistentID
            )
            songsQuery.addFilterPredicate(predicate)
            let songs = songsQuery.items?.map(Song.init(item:))
            return songs ?? []
        }
    )
}

public extension DependencyValues {
    var musicRepository: MusicRepository {
        get { self[MusicRepository.self] }
        set { self[MusicRepository.self] = newValue }
    }
}
