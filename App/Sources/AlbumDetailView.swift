//
//  AlbumDetailView.swift
//  Music
//
//  Created by tilltue on 12/2/24.
//

import SwiftUI
import MediaPlayer

struct AlbumDetailView: View {
    let album: MPMediaItem
    
    var body: some View {
        Text(album.albumTitle ?? "")
    }
}
