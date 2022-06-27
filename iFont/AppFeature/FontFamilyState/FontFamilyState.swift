//
//  FontFamilyState.swift
//  iFont
//
//  Created by Klajd Deda on 6/27/22.
//

import Foundation
import ComposableArchitecture

struct FontFamilyState: Equatable, Hashable {
    var fontFamily: FontFamily
    var isSelected: Bool = false
    var fonts: [Font] {
        fontFamily.fonts
    }

    init(_ fontFamily: FontFamily) {
        self.fontFamily = fontFamily
    }
}

extension FontFamilyState: Identifiable {
    var id: String {
        fontFamily.name
    }
}

enum FontFamilyAction: Equatable {
    case onAppear
}

struct FontFamilyEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var fontClient: FontClient
}

extension FontFamilyState {
    static let reducer = Reducer<FontFamilyState, FontFamilyAction, FontFamilyEnvironment>.combine(
        Reducer { state, action, environment in
            switch action {
            case .onAppear:
                return .none
            }
        }
    )
}


// TODO: add the mock state

//extension FontFamilyState {
//    static let liveState = FontFamilyState(fonts: [Font]())
//    static let mockState = FontFamilyState(
//        fontPath: "/Users/kdeda/Library/Fonts",
//        fonts: [Font(name: "KohinoorBangla", familyName: "KohinoorBangla")]
//    )
//}
//
//extension FontFamilyState {
//    static let liveStore = Store(
//        initialState: liveState,
//        reducer: FontFamilyState.reducer,
//        environment: FontFamilyEnvironment(
//            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
//            fontClient: FontClient.live
//        )
//    )
//    
//    static let mockStore = Store(
//        initialState: mockState,
//        reducer: FontFamilyState.reducer,
//        environment: FontFamilyEnvironment(
//            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
//            fontClient: FontClient.live
//        )
//    )
//}
