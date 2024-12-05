//
//  MusicAlbum.swift
//  Repository
//
//  Created by tilltue on 12/5/24.
//

import UIKit
import MediaPlayer

public struct MusicAlbum: Equatable, Hashable {
    public let albumId: UInt64
    public let albumTitle: String?
    public let artist: String?
    public let genre: String?
    public let getImages: ((CGSize) -> UIImage?)?
    
    public init(
        albumId: UInt64,
        albumTitle: String?,
        artist: String?,
        genre: String?,
        getImages: ((CGSize) -> UIImage?)?
    )
    {
        self.albumId = albumId
        self.albumTitle = albumTitle
        self.artist = artist
        self.genre = genre
        self.getImages = getImages
    }
    
    public static func==(lhs: MusicAlbum, rhs: MusicAlbum) -> Bool {
        lhs.albumId == rhs.albumId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(albumId)
    }
}

extension MusicAlbum {
    init(album: MPMediaItem) {
        self.albumId = album.albumPersistentID
        self.albumTitle = album.albumTitle
        self.artist = album.artist
        self.genre = album.genre
        self.getImages = album.artwork?.image(at:)
    }
}
