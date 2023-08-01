//
//  MainView.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 21/07/23.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject private var viewModel = MainViewModel()
    
    var items: [GridItem] {
        Array(repeating: .init(.adaptive(minimum: 120)), count: 2)
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                ScrollView{
                    Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                    TextField("Search name or id", text: $viewModel.searchText)
                                       .padding(.horizontal, 40)
                                       .frame(width: UIScreen.main.bounds.width - 50, height: 45, alignment: .leading)
                                       .background(Color(#colorLiteral(red: 0.9294475317, green: 0.9239223003, blue: 0.9336946607, alpha: 1)))
                                       .clipped()
                                       .cornerRadius(10)
                                       .overlay(
                                           HStack {
                                               Image(systemName: "magnifyingglass")
                                                   .foregroundColor(.gray)
                                                   .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                   .padding(.leading, 16)
                                           }
                                       )
                    LazyVGrid(columns: items, spacing: 20){
                        ForEach(viewModel.pokemons, id: \.self){ value in
                            NavigationLink(destination: PokemonDetailView()){
                                PokemonCell(pokemon: value)
                                    .task {
                                        if value == viewModel.pokemons.last{
                                            let _ = viewModel.getPokemons()
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
        .onAppear(perform: viewModel.getPokemons)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
