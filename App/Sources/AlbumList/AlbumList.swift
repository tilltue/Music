//
//  AlbumList.swift
//  Music
//
//  Created by tilltue on 12/1/24.
//

import Foundation
import ComposableArchitecture
import Repository

@Reducer
struct AlbumList {
    @ObservableState
    struct State: Equatable {
        var albums: [MusicAlbum] = []
    }
    
    enum Action {
        case load
        case setAlbums([MusicAlbum])
    }
    
    @Dependency(\.musicRepository) var musicRepository
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .load:
                return permissionCheck()
            case .setAlbums(let albums):
                state.albums = albums
                return .none
            }
        }
    }
    
    private func permissionCheck() -> Effect<Action> {
        switch musicRepository.authorizationStatus() {
        case .notDetermined:
            return .run { send in
                let status = await musicRepository.requestAuthorization()
                status == .authorized ? await loadAlbums(send) : ()//TODO: 권한별 조치
            }
        case .authorized:
            return .run { send in
                await loadAlbums(send)
            }
        case .denied:
            return .none // TODO: 설정 이동
        case .restricted:
            return .none // TODO: 접근 제한 되었음을 알림
        @unknown default:
            return .none
        }
    }
    
    private func loadAlbums(_ send: Send<Action>) async {
        await send(.setAlbums(musicRepository.fetchAlbums()))
    }
}
