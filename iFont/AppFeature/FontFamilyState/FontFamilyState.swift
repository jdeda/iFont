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
    var expanded: Bool = false
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

// TODO: Mock state should fetch fonts.
extension FontFamilyState {
    static let mockState = FontFamilyState(
        FontFamily(
            name: "KohinoorBangla",
            fonts: [Font(name: "KohinoorBangla", familyName: "KohinoorBangla")]
        )
    )
}

extension FontFamilyState {
    static let mockStore = Store(
        initialState: mockState,
        reducer: reducer,
        environment: .init(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            fontClient: FontClient.live
        )
    )
}

