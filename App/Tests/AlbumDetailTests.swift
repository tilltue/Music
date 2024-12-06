//
//  AlbumDetailTests.swift
//  MusicTests
//
//  Created by tilltue on 12/5/24.
//

import Testing
import ComposableArchitecture
import Repository

@testable import Music

@Suite("앨범 상세 테스트")
struct AlbumDetailTests {
    @Test("플레이리스트 로드")
    @MainActor
    func playList() async {
        // Arrange
        let sut = TestStore(initialState: AlbumDetail.State(album: MusicAlbum.dummy)) {
            AlbumDetail()
        } withDependencies: {
            $0.musicRepository.authorizationStatus = { .notDetermined }
            $0.musicRepository.fetchSongs = { _ in Song.dummis }
        }
        
        // Act
        await sut.send(.load)
       
        // Assert
        await sut.receive(\.setSongs) {
            $0.album = MusicAlbum.dummy
            $0.songs = Song.dummis
        }
    }
    
    @Test("전체 곡 재생")
    @MainActor
    func playAll() async {
        // Arrange
        var spySetPlayList: [Song]?
        let sut = TestStore(initialState: AlbumDetail.State(album: MusicAlbum.dummy)) {
            AlbumDetail()
        } withDependencies: {
            $0.musicRepository.authorizationStatus = { .notDetermined }
            $0.musicRepository.fetchSongs = { _ in Song.dummis }
            $0.musicPlayer.setPlayList = { spySetPlayList = $0 }
        }
        sut.exhaustivity = .off
        await sut.send(.load)
        
        // Act
        await sut.send(.play(nil))
       
        // Assert
        #expect(spySetPlayList == Song.dummis)
    }
    
    @Test("선택한 곡부터 재생 1,2,3 -> 2 선택시 -> 2,3,1 순")
    @MainActor
    func playWithSelectedSong() async {
        // Arrange
        var spySetPlayList: [Song]?
        let sut = TestStore(initialState: AlbumDetail.State(album: MusicAlbum.dummy)) {
            AlbumDetail()
        } withDependencies: {
            $0.musicRepository.authorizationStatus = { .notDetermined }
            $0.musicRepository.fetchSongs = { _ in Song.dummis }
            $0.musicPlayer.setPlayList = { spySetPlayList = $0 }
        }
        sut.exhaustivity = .off
        await sut.send(.load)
        
        // Act
        await sut.send(.play(Song(songId: 4, songTitle: nil)))
       
        // Assert
        #expect(spySetPlayList?.map { $0.songId } == [4,5,6,7,8,9,0,1,2,3])
    }
    
    @Test("전체 랜덤 재생")
    @MainActor
    func shuffledPlay() async {
        // Arrange
        var spySetPlayList: [Song]?
        let sut = TestStore(initialState: AlbumDetail.State(album: MusicAlbum.dummy)) {
            AlbumDetail()
        } withDependencies: {
            $0.musicRepository.authorizationStatus = { .notDetermined }
            $0.musicRepository.fetchSongs = { _ in Song.dummis }
            $0.musicPlayer.setPlayList = { spySetPlayList = $0 }
        }
        sut.exhaustivity = .off
        await sut.send(.load)
        
        var actualShuffledCount = 0
        for _ in 0..<100 {
            // Act
            await sut.send(.shufflePlay)
            
            // Assert
            if spySetPlayList != Song.dummis {
                actualShuffledCount += 1
            }
        }
        print("actualShuffledCount: \(actualShuffledCount)")
        #expect(actualShuffledCount > 95)
    }
}

private extension MusicAlbum {
    static var dummy: MusicAlbum {
        MusicAlbum(
            albumId: 1,
            albumTitle: "Dummy Album",
            artist: "Dummy Artist",
            genre: "Dummy Genre",
            getImages: { _ in nil }
        )
    }
}

private extension Song {
    static var dummis: [Song] {
        Array(0..<10).map {
            Song(
                songId: $0,
                songTitle: "Title \($0)"
            )
        }
    }
        
}
