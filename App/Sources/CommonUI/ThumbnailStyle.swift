//
//  ThumbnailStyle.swift
//  Music
//
//  Created by tilltue on 12/2/24.
//

import SwiftUI

private struct ThumbnailStyle: ViewModifier {
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    
    init(size: CGSize, cornerRadius: CGFloat = 10) {
        self.width = size.width
        self.height = size.height
        self.cornerRadius = cornerRadius
    }
    
    func body(content: Content) -> some View {
        content
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

extension View {
    func applyThumbnail(width: CGFloat, cornerRadius: CGFloat = 10) -> some View {
        self.modifier(
            ThumbnailStyle(
                size: .init(width: width, height: width),
                cornerRadius: cornerRadius
            )
        )
    }
}
