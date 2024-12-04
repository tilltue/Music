//
//  VolumeView.swift
//  Music
//
//  Created by tilltue on 12/5/24.
//

import SwiftUI
import MediaPlayer

struct VolumeView: UIViewRepresentable {
    func makeUIView(context: Context) -> MPVolumeView {
        let volumeView = MPVolumeView(frame: .zero)
        volumeView.showsVolumeSlider = true
        volumeView.showsRouteButton = false
        return volumeView
    }
    
    func updateUIView(_ uiView: MPVolumeView, context: Context) {
        
    }
}
