//
//  FullPlayerView.swift
//  Music
//
//  Created by tilltue on 12/4/24.
//

import SwiftUI
import ComposableArchitecture
import MediaPlayer

struct FullPlayerView: View {
    let store: StoreOf<FullPlayer>
    var animation: Namespace.ID
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore  in
            ZStack {
                Color.black
                    .background(.thinMaterial)
                    .blur(radius: 10)
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .blur(radius: 5)
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.gray)
                        .frame(width: 30, height: 4)
                        .padding(.top, 10)
                    HStack {
                        let albumImage = viewStore.currentSong?.artwork?.image(at: .init(width: 70, height: 70))
                        AlbumImage(width: 70, cornerRadius: 5, albumImage: albumImage)
                            .background(.black.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .matchedGeometryEffect(id: "albumImage", in: animation)
                        
                        VStack {
                            Text(viewStore.currentSong?.title ?? "")
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .medium))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .matchedGeometryEffect(id: "song", in: animation)
                            
                            Text(viewStore.currentSong?.artist ?? "")
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
                        isShuffle: viewStore.isShuffle,
                        isReapeat: viewStore.isRepeat,
                        shuffleTap: {
                            store.send(.shuffle)
                        },
                        repeatTap: {
                            store.send(.repeat)
                        }
                    )
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    VStack(spacing: 30) {
                        progressView
                        
                        PlayControlButtonsView(
                            isPlaying: viewStore.isPlaying,
                            seekBackwardTap: {
                                store.send(.seekBackword)
                            },
                            playTap: {
                                store.send(.playToggle)
                            },
                            seekForwardTap: {
                                store.send(.seekForword)
                            }
                        )
                        .padding(.bottom, 30)
                        
                        VolumeControlView()
                    }
                    .padding(.bottom, 50)
                }
            }
            .background(.black)
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    var progressView: some View {
        WithViewStore(store, observe: { $0 }) { viewStore  in
            VStack {
                Slider(
                    value: viewStore.binding(
                        get: \.progress,
                        send: FullPlayer.Action.updateProgress
                    ),
                    in: 0...1,
                    onEditingChanged: { isEditing in
                        if !isEditing {
                            store.send(.setProgress(viewStore.progress))
                        }
                    })
                HStack {
                    Text(((viewStore.currentSong?.playbackDuration ?? 0) * viewStore.progress).formatTime())
                        .foregroundColor(.white.opacity(0.7))
                        .font(.caption)
                    Spacer()
                    Text("-\(viewStore.currentSong?.playbackDuration.formatTime() ?? "")")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.caption)
                }
                .padding(.vertical, 5)
            }
            .padding(.horizontal, 30)
            .safeAreaPadding(.bottom)
        }
    }
}

private extension TimeInterval {
    func formatTime() -> String {
        let totalSeconds = Int(self)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

private struct VolumeControlView: View {
    var body: some View {
        HStack {
            Image(systemName: "speaker.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .foregroundColor(.white)
            VolumeView()
                .frame(height: 20)
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
    var isPlaying: Bool
    var seekBackwardTap: () -> Void
    var playTap: () -> Void
    var seekForwardTap: () -> Void
    
    var body: some View {
        HStack(spacing: 60) {
            ControlButton(
                iconName: "backward.fill"
            ).onTapGesture{ _ in seekBackwardTap() }
            
            ControlButton(
                iconName: isPlaying ? "pause.fill" : "play.fill"
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
    let isShuffle: Bool
    let isReapeat: Bool
    
    let shuffleTap: () -> Void
    var repeatTap: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            ControlButton(
                iconName: "shuffle",
                isSelected: isShuffle
            )
            .onTapGesture{ _ in shuffleTap() }
            
            ControlButton(
                iconName: "repeat",
                isSelected: isReapeat
            )
            .onTapGesture{ _ in repeatTap() }
            
            Spacer()
        }
        .padding(.vertical, 10)
    }
    
    struct ControlButton: View {
        let iconName: String
        let isSelected: Bool
        
        var body: some View {
            HStack {
                Image(systemName: iconName)
                    .frame(width: 10, height: 10)
                    .foregroundColor(.white)
            }
            .frame(minWidth: 100, minHeight: 30)
            .background(isSelected ? Color.white.opacity(0.3) : Color.gray.opacity(0.3))
            .cornerRadius(5)
        }
    }
}

//#Preview {
//    FullPlayerView()
//}
