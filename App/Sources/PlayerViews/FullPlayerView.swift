//
//  FullPlayerView.swift
//  Music
//
//  Created by tilltue on 12/4/24.
//

import SwiftUI

struct FullPlayerView: View {
    var animation: Namespace.ID
    
    var body: some View {
        ZStack {
            Color.black
                .background(.thinMaterial)
                .blur(radius: 10)
                .ignoresSafeArea()
            Rectangle()
                .fill(.ultraThinMaterial)
                .blur(radius: 5)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(.gray)
                    .frame(width: 30, height: 4)
                HStack {
                    AlbumImage(width: 70, cornerRadius: 5, albumImage: nil)
                        .background(.black.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .matchedGeometryEffect(id: "albumImage", in: animation)
                    
                    VStack {
                        Text("Song Title")
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .medium))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .matchedGeometryEffect(id: "song", in: animation)
                        
                        Text("Artist Name")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .matchedGeometryEffect(id: "artist", in: animation)
                    }
                    .padding(.leading, 5)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                .padding(.horizontal, 30)
                
                PlayModeControlButtonsView(
                    shuffleTap: { },
                    repeatTap: { }
                )
                .padding(.horizontal, 30)
                
                Spacer()
                
                VStack(spacing: 30) {
                    progressView
                    
                    PlayControlButtonsView(
                        seekBackwardTap: {},
                        playTap: {},
                        seekForwardTap: {}
                    )
                    .padding(.bottom, 30)
                    
                    VolumeControlProgressView()
                }
                .padding(.bottom, 50)
            }
        }
        .background(.black)
        .edgesIgnoringSafeArea(.all)
    }
    
    var progressView: some View {
        VStack {
            DraggableProgressView()
            HStack {
                Text("0:03")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.caption)
                Spacer()
                Text("-3:31")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.caption)
            }
            .padding(.vertical, 5)
        }
        .padding(.horizontal, 30)
        .safeAreaPadding(.bottom)
    }
}

private struct VolumeControlProgressView: View {
    var body: some View {
        HStack {
            Image(systemName: "speaker.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .foregroundColor(.white)
            DraggableProgressView()
            Image(systemName: "speaker.wave.3.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 17, height: 17)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 30)
    }
}

private struct PlayControlButtonsView: View {
    var seekBackwardTap: () -> Void
    var playTap: () -> Void
    var seekForwardTap: () -> Void
    
    var body: some View {
        HStack(spacing: 60) {
            ControlButton(
                iconName: "backward.fill"
            ).onTapGesture{ _ in seekBackwardTap() }
            
            ControlButton(
                iconName: "play.fill"
            ).onTapGesture{ _ in playTap() }
            
            ControlButton(
                iconName: "forward.fill"
            ).onTapGesture{ _ in seekForwardTap() }
        }
    }
    
    struct ControlButton: View {
        let iconName: String
        
        var body: some View {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
                .foregroundColor(.white)
        }
    }
}

private struct PlayModeControlButtonsView: View {
    var shuffleTap: () -> Void
    var repeatTap: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            ControlButton(
                iconName: "shuffle"
            ).onTapGesture{ _ in shuffleTap() }
            
            ControlButton(
                iconName: "repeat"
            ).onTapGesture{ _ in repeatTap() }
            
            Spacer()
        }
        .padding(.vertical, 10)
    }
    
    struct ControlButton: View {
        let iconName: String
        
        var body: some View {
            HStack {
                Image(systemName: iconName)
                    .frame(width: 10, height: 10)
                    .foregroundColor(.white)
            }
            .frame(minWidth: 100, minHeight: 30)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(5)
        }
    }
}

private struct DraggableProgressView: View {
    @State private var progress: CGFloat = 0.5
    
    var body: some View {
        GeometryReader { geometry in
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .white))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let newProgress = value.location.x / geometry.size.width
                            progress = min(max(newProgress, 0), 1)
                        }
                )
        }
        .frame(height: 5)
    }
}

//#Preview {
//    FullPlayerView()
//}
