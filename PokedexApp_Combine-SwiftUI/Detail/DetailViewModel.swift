//
//  DetailViewModel.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 01/08/23.
//

import Foundation

class DetailViewModel: ObservableObject{
    
    let pokemon: PokemonModel
    
    init(pokemonModel: PokemonModel) {
        self.pokemon = pokemonModel
    }
    
}
