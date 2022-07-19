import ComposableArchitecture
import SwiftUI

struct AppView: View {
  @State var fontGroup: String? = "All Fonts"
  
  var body: some View {
    NavigationView {
      Sidebar(selection: $fontGroup)
      MasterView(collection: "All Fonts")
      DetailView(item: nil)
    }
  }
}

private struct Sidebar: View {
  @Binding var selection: String?
  
  var body: some View {
    List(selection: $selection) {
      Group {
        NavigationLink(
          tag: "All Fonts",
          selection: $selection,
          destination: { MasterView(collection: "All Fonts") },
          label: { Label("All Fonts", systemImage: "f.square") }
        )
        NavigationLink(
          tag: "Computer",
          selection: $selection,
          destination: { MasterView(collection: "Computer") },
          label: { Label("Computer", systemImage: "laptopcomputer") }
        )
        NavigationLink(
          tag: "User",
          selection: $selection,
          destination: { MasterView(collection: "User") },
          label: {
            Label("User", systemImage: "person.circle")
          }
        )
      }
      Section("Smart Collections") {
        ForEach(["English", "Fixed Width"], id: \.self) { item in
          NavigationLink(
            tag: item.description,
            selection: $selection,
            destination: { MasterView(collection: item) },
            label: {
              Label(item.description, systemImage: "gear")
                .accentColor(.gray)
            }
          )
        }
      }
      Section("Collections") {
        ForEach(["Fun", "Modern", "PDF", "Traditional", "Web"], id: \.self) { item in
          NavigationLink(
            tag: item.description,
            selection: $selection,
            destination: { MasterView(collection: item) },
            label: {
              Label(item.description, systemImage: "square.on.square")
              .accentColor(.cyan)
            }
          )
        }
      }
    }
  }
}

private struct MasterView: View {
  let collection: String
  var items = 0..<Int.random(in: 1...100)
  @State var selection: Int? = nil
  
  var body: some View {
    List(selection: $selection) {
      ForEach(items, id: \.self) { item in
        NavigationLink(
          tag: item,
          selection: $selection,
          destination: { DetailView(item: item) },
          label: { Text("Untitled \(item.description)") }
        )
      }
    }
    .navigationTitle(collection)
    .navigationSubtitle("Fonts \(items.count)")
    .toolbar {
      Button(action: {}) {
        Label("", systemImage: "plus")
      }
      Button(action: {}) {
        Label("", systemImage: "checkmark.square")
      }
    }
  }
}

private struct DetailView: View {
  let item: Int?
  let displayOptions = ["text.aligncenter", "square.grid.2x2", "info.circle", "character.cursor.ibeam"]
  @State var selection = "text.aligncenter"
  @State var search = ""
  
  var body: some View {
    Group {
      if let i = item {
        Text("Untitled \(i)")
      } else {
        Text("No selection")
          .foregroundStyle(.secondary)
      }
    }
    .searchable(text: $search)
    .toolbar {
      ToolbarItemGroup {
        Spacer()
        
        Picker(selection: $selection, label: EmptyView()) {
          ForEach(displayOptions, id: \.self) { selection in
            Label("", systemImage: selection)
          }
        }
        .pickerStyle(.segmented)
      }
    }
  }
}

// MARK: - SwiftUI Previews

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView()
  }
}

