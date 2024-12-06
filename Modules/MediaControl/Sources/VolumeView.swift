//
//  VolumeView.swift
//  Music
//
//  Created by tilltue on 12/5/24.
//

import SwiftUI
import MediaPlayer

public struct VolumeView: UIViewRepresentable {
    public init() {}
    
    public func makeUIView(context: Context) -> MPVolumeView {
        let volumeView = MPVolumeView(frame: .zero)
        volumeView.showsVolumeSlider = true
        return volumeView
    }
    
    public func updateUIView(_ uiView: MPVolumeView, context: Context) {
        
    }
}
