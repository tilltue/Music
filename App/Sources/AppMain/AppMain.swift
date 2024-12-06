//
//  AppMain.swift
//  Music
//
//  Created by tilltue on 12/3/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppMain {
    @ObservableState
    struct State: Equatable {
        var fullPlayerStore = Store(initialState: FullPlayer.State()) {
            FullPlayer()
        }
    }
    
    enum Action {
    }
    
    var body: some Reducer<State, Action> {
        Reduce { _, _ in
            return .none
        }
    }
}
