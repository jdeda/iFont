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
    var isExpanded: Bool = false
    var selectedChild: Font? = nil
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
    case toggleSelection
    case toggleExpansion
    case toggleChildSelection(Font)
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
                
            case .toggleSelection:
                state.isSelected.toggle()
                state.selectedChild = nil
                Logger.log("familyID: \(state.id) isSelected: \(state.isSelected)")
                return .none
                
            case .toggleExpansion:
                state.isExpanded.toggle()
                Logger.log("familyID: \(state.id) isExpanded: \(state.isExpanded)")
                return .none
                
            case let .toggleChildSelection(font):
                state.isSelected = false
                state.selectedChild = font
                Logger.log("child: \(font) isSelected")
                return .none
            }
        }
    )
}

extension FontFamilyState {
    static let mockState = FontFamilyState(
        FontFamily(
            name: "Foobar",
            fonts: [
                Font(name: "Super", familyName: "Foobar"),
                Font(name: "Mega", familyName: "Foobar"),
                Font(name: "Ultra", familyName: "Foobar"),
                Font(name: "Supreme", familyName: "Foobar")
            ]
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

