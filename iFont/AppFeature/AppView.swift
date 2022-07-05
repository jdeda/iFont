//
//  AppView.swift
//  iFont
//
//  Created by Klajd Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

func labeledImage(systemName: String, label: String) -> some View {
    HStack {
        Image(systemName: systemName)
            .frame(width: 20, height: 20)
        Text(label)
    }
}

func labeledImage(systemName: String, label: String, accent: Color) -> some View {
    HStack {
        Image(systemName: systemName)
            .foregroundColor(accent)
            .frame(width: 20, height: 20)
        Text(label)
    }
}

struct FontCollectionsSideBarView: View {
    var body: some View {
        List {
            Section {
                labeledImage(systemName: "f.square", label: "All Fonts", accent: .accentColor)
                labeledImage(systemName: "laptopcomputer", label: "Computer", accent: .accentColor)
                labeledImage(systemName: "person.crop.square", label: "User", accent: .accentColor)
            } header: {
                Text("Libraries")
            }
            Section {
                labeledImage(systemName: "gearshape", label: "English")
                labeledImage(systemName: "gearshape", label: "Fixed Width")
            } header: {
                Text("Smart Collections")
            }
            Section {
                labeledImage(systemName: "square.on.square", label: "Fun", accent: .cyan)
                labeledImage(systemName: "square.on.square", label: "Modern", accent: .cyan)
                labeledImage(systemName: "square.on.square", label: "PDF", accent: .cyan)
                labeledImage(systemName: "square.on.square", label: "Traditional", accent: .cyan)
                labeledImage(systemName: "square.on.square", label: "Web", accent: .cyan)
                labeledImage(systemName: "square.on.square", label: "All", accent: .cyan)
            } header: {
                Text("Collections")
            }
        }
    }
}
struct AppView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                FontCollectionsSideBarView()
                Text("Selected Collection")
                Text("Selected Collection details")
            }
            .onAppear {
                viewStore.send(AppAction.onAppear)
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: AppState.mockStore)
    }
}
