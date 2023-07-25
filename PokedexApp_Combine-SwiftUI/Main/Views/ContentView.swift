//
//  ContentView.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 21/07/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var viewModel = MainViewModel()
    
    var items: [GridItem] {
        Array(repeating: .init(.adaptive(minimum: 120)), count: 2)
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                ScrollView{
                    LazyVGrid(columns: items, spacing: 20){
                        ForEach(viewModel.pokemons, id: \.self){ value in
                            NavigationLink(destination: PokemonDetailView()){
                                PokemonCell(pokemon: value)
                                    .task {
                                        if value == viewModel.pokemons.last{
                                            let _ = viewModel.fetchPokemons()
                                        }
                                    }
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20))
                    LoaderView()
                }
            }
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
