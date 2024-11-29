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
    public var fetchAlbums: () -> [MPMediaItem]
    public var fetchSongs: (MPMediaItem) -> [MPMediaItem]
}

extension MusicRepository: DependencyKey {
    public static let liveValue = Self(
        authorizationStatus: { MPMediaLibrary.authorizationStatus() },
        requestAuthorization: { await MPMediaLibrary.requestAuthorization() },
        fetchAlbums: {
            let albumsQuery = MPMediaQuery.albums()
            let items = albumsQuery.collections?.compactMap { $0.representativeItem }
            return items ?? []
        },
        fetchSongs: {
            let songsQuery = MPMediaQuery.songs()
            let predicate = MPMediaPropertyPredicate(
                value: $0.persistentID,
                forProperty: MPMediaItemPropertyAlbumPersistentID,
                comparisonType: .equalTo
            )
            songsQuery.addFilterPredicate(predicate)
            return songsQuery.items ?? []
        }
    )
}

public extension DependencyValues {
    var musicRepository: MusicRepository {
        get { self[MusicRepository.self] }
        set { self[MusicRepository.self] = newValue }
    }
}
