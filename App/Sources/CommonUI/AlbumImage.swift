//
//  AlbumImage.swift
//  Music
//
//  Created by tilltue on 12/2/24.
//

import SwiftUI

struct AlbumImage: View {
    let width: CGFloat
    let cornerRadius: CGFloat
    let albumImage: UIImage?
    
    init(width: CGFloat, cornerRadius: CGFloat = 10, albumImage: UIImage?) {
        self.width = width
        self.cornerRadius = cornerRadius
        self.albumImage = albumImage
    }
    
    var body: some View {
        if let albumImage {
            Image(uiImage: albumImage)
                .resizable()
                .applyThumbnail(width: width, cornerRadius: cornerRadius)
        } else {
            EmptyAlbumImage()
                .applyThumbnail(width: width, cornerRadius: cornerRadius)
        }
    }
}

private struct EmptyAlbumImage: View {
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width / 3
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .overlay(
                    Image(systemName: "music.note")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width, height: width)
                        .foregroundColor(.gray)
                )
        }
    }
}
