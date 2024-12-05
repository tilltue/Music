//
//  AlbumListTests.swift
//  Music
//
//  Created by tilltue on 12/1/24.
//

import Testing
import ComposableArchitecture
import Repository

@testable import Music

@Suite("앨범 목록 테스트")
struct AlbumListTests {
    @Test("앨범 접근 권한 필요시 요청")
    @MainActor
    func needAuthorization() async {
        var spyCalledRequestAuthorization = false
        // Arrange
        let sut = TestStore(initialState: AlbumList.State()) {
            AlbumList()
        } withDependencies: {
            $0.musicRepository.authorizationStatus = { .notDetermined }
            $0.musicRepository.requestAuthorization = {
                spyCalledRequestAuthorization = true
                return .denied
            }
        }
        
        // Act
        await sut.send(.load)
        
        // Assert
        #expect(spyCalledRequestAuthorization == true)
    }
    
    @Test("앨범 접근 권한 수락한 경우 앨범 로드")
    @MainActor
    func loadedAlbums_acceptAuthorization() async {
        // Arrange
        let sut = TestStore(initialState: AlbumList.State()) {
            AlbumList()
        } withDependencies: {
            $0.musicRepository.authorizationStatus = { .notDetermined }
            $0.musicRepository.requestAuthorization = { .authorized }
            $0.musicRepository.fetchAlbums = { MusicAlbum.dummies }
        }
        
        // Act
        await sut.send(.load)
        
        // Assert
        await sut.receive(\.setAlbums) {
            $0.albums = MusicAlbum.dummies
        }
    }
    
    @Test("앨범 접근 권한이 있는 경우 앨범 로드")
    @MainActor
    func loadAlbums_alreadyAuthoirzed() async {
        var spyCalledRequestAuthorization = false
        // Arrange
        let sut = TestStore(initialState: AlbumList.State()) {
            AlbumList()
        } withDependencies: {
            $0.musicRepository.authorizationStatus = { .authorized }
            $0.musicRepository.fetchAlbums = { MusicAlbum.dummies }
        }
        
        // Act
        await sut.send(.load)
        
        // Assert
        await sut.receive(\.setAlbums) {
            $0.albums = MusicAlbum.dummies
        }
    }
}

private extension MusicAlbum {
    static var dummies: [MusicAlbum] {
        Array(0..<10).map {
            MusicAlbum(
                albumId: $0,
                albumTitle: "Title \($0)",
                artist: "Artist \($0)",
                genre: "Genre \($0)",
                getImages: { _ in nil }
            )
        }
    }
}
