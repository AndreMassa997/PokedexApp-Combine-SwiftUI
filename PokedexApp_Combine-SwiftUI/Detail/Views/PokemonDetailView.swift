//
//  PokemonDetailView.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 21/07/23.
//

import SwiftUI

struct PokemonDetailView: View {
    
    @ObservedObject var viewModel: DetailViewModel
    
    init(pokemonModel: PokemonModel){
        viewModel = DetailViewModel(pokemonModel: pokemonModel)
    }
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [
                Color(viewModel.pokemon.types?.first?.type.name.mainColor ?? .clear),
                Color(viewModel.pokemon.types?.first?.type.name.endColor ?? .clear)]),
                           startPoint: .leading,
                           endPoint: .trailing)
            .scaledToFill()
            ScrollView{
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}
