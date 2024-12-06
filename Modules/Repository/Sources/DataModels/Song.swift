//
//  Song.swift
//  Repository
//
//  Created by tilltue on 12/5/24.
//

import UIKit
import MediaPlayer

public struct Song: Equatable, Hashable {
    public let songId: UInt64
    public let title: String?
    
    public init(
        songId: UInt64,
        songTitle: String?
    )
    {
        self.songId = songId
        self.title = songTitle
    }
    
    public static func==(lhs: Song, rhs: Song) -> Bool {
        lhs.songId == rhs.songId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(songId)
    }
}

extension Song {
    init(item: MPMediaItem) {
        self.songId = item.persistentID
        self.title = item.title
    }
}
