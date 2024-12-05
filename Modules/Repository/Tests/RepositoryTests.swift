//
//  RepositoryTests.swift
//  RepositoryTests
//
//  Created by tilltue on 11/30/24.
//

import Testing
import ComposableArchitecture
import MediaPlayer

@testable import Repository

@Suite("Music Repository 테스트 : TCA DependencyValues 확장 구현")
struct MusicRepositoryTests {
    @Test("Music Repo 인터페이스 유효성 체크", arguments: [
        MPMediaLibraryAuthorizationStatus.notDetermined,
        MPMediaLibraryAuthorizationStatus.denied,
        MPMediaLibraryAuthorizationStatus.restricted,
        MPMediaLibraryAuthorizationStatus.authorized
    ])
    func dependencyWithValues(_ authStatus: MPMediaLibraryAuthorizationStatus) async {
        await withDependencies {
            // Arrange
            $0.musicRepository = MusicRepository(
                authorizationStatus: { authStatus },
                requestAuthorization: { authStatus },
                fetchAlbums: { [] },
                fetchSongs: { _ in [] }
            )
        } operation: {
            // Act
            @Dependency(\.musicRepository) var musicRepository
            
            // Assert
            #expect(musicRepository.authorizationStatus() == authStatus)
            let status = await musicRepository.requestAuthorization()
            #expect(status == authStatus)
            #expect(musicRepository.fetchAlbums() == [])
            #expect(musicRepository.fetchSongs(0) == [])
        }
    }
}

