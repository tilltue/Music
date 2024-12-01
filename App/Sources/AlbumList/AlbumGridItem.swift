//
//  AlbumGridItem.swift
//  Music
//
//  Created by tilltue on 12/2/24.
//

import SwiftUI
import MediaPlayer

struct AlbumGridItem: View {
    let album: MPMediaItem
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                let width = geometry.size.width - 20
                if let artwork = album.artwork {
                    Image(uiImage: artwork.image(at: .init(width: width, height: width)) ?? UIImage())
                        .resizable()
                        .applyThumbnail(width: width)
                } else {
                    DefaultAlbumImage()
                        .applyThumbnail(width: width)
                }
                Text(album.albumTitle ?? "")
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                Text(album.artist ?? "")
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

private struct DefaultAlbumImage: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .overlay(
                Image(systemName: "music.note")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            )
    }
} 
