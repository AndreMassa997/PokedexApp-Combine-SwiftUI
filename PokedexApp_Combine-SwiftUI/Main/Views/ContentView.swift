//
//  ContentView.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 21/07/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(($viewModel.pokemons.count).description)
        }
        .padding()
        .onAppear(perform: viewModel.fetchPokemons)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
