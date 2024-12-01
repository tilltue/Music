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
                let albumImage = album.artwork?.image(at: .init(width: width, height: width))
                AlbumImage(width: width, albumImage: albumImage)
                
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
