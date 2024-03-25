//
//  ContentView.swift
//  Demo
//
//  Created by Narumichi Kubo on 2024/03/25.
//

import SwiftUI
import ApolloAPI

enum UIState {
    case unInitialized
    case loading
    case loaded(FilmListFragment)
    case error(String)
    
    var isError: Bool {
        guard case .error = self else { return false }
        return true
    }
}

struct FilmListView: View {
    @State var state: UIState = .unInitialized

    var body: some View {
        switch state {
        case .unInitialized:
            Spacer()
                .task {
                    await fetch()
                }
        case .loading:
            ProgressView()
        case let .loaded(fragment):
            if let films = fragment.films {
                List(films, id: \.self) { film in
                    Text(film?.title ?? "")
                }
            }
        case let .error(message):
            Color.clear.alert(isPresented: .init(
                get: { state.isError },
                set: { if !$0 { state = .unInitialized }}
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func fetch() async {
        state = .loading
        let result = await DemoApolloClient().client.fetchQuery(query: GetAllFilmsQuery())
        switch result {
        case let .success(data):
            guard let allFilms = data.allFilms else { return }
            state = .loaded(allFilms.fragments.filmListFragment)
        case let .failure(error):
            state = .error(error.localizedDescription)
        }
    }
}

#Preview {
    FilmListView()
}
