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
            .scaledToFill()
            ScrollView{
                ImageCarouselView(imagesUrl: viewModel.getUrl(), color: viewModel.pokemon.types?.first?.type.name.mainColor ?? .clear)
                    .frame(width: 200, height: 200)
                
            }
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading){
                Button{
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("arrow_left")
                        .frame(width: 30, height: 30)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
