//
//  PokemonDetailView.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 21/07/23.
//

import SwiftUI

struct PokemonDetailView: View {
    
    @ObservedObject var viewModel: DetailViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
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
            .edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack(spacing: 0){
                    Button{
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("arrow_left")
                    }
                    .frame(maxWidth: .infinity, maxHeight: 30, alignment: .leading)
                    .padding(.leading, 20)
                    ImageCarouselView(imagesUrl: viewModel.urls, color: viewModel.pokemon.types?.first?.type.name.mainColor ?? .clear, name: viewModel.pokemon.name, id: String.init(format: "#%03d", viewModel.pokemon.id))
                    ChipsView(types: viewModel.types)
                    DimensionsView(weight: Float(viewModel.pokemon.weight ?? 0)/10, height: Float(viewModel.pokemon.height ?? 0)/10, color: viewModel.pokemon.types?.first?.type.name.mainColor ?? .clear)
                    StatsView(stats: viewModel.pokemon.stats ?? [], color: Color(viewModel.pokemon.types?.first?.type.name.mainColor ?? .clear))
                    AbilitiesView(abilities: viewModel.pokemon.abilities ?? [], color: Color(viewModel.pokemon.types?.first?.type.name.mainColor ?? .clear))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
