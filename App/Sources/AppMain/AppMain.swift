//
//  AppMain.swift
//  Music
//
//  Created by tilltue on 12/3/24.
//

import Foundation
import ComposableArchitecture
import MediaPlayer

@Reducer
struct AppMain {
    @ObservableState
    struct State: Equatable {
    }
    
    enum Action {
    }
    
    @Dependency(\.musicRepository) var musicRepository
    
    var body: some Reducer<State, Action> {
        Reduce { _, _ in
            return .none
        }
    }
}
