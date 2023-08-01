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
    
    func getUrl() -> [URL]{
        [pokemon.sprites?.other?.officialArtwork?.frontDefault,
            pokemon.sprites?.backDefault,
            pokemon.sprites?.backFemale,
            pokemon.sprites?.backShiny,
            pokemon.sprites?.backShinyFemale,
            pokemon.sprites?.frontDefault,
            pokemon.sprites?.frontFemale,
            pokemon.sprites?.frontShiny,
            pokemon.sprites?.frontShinyFemale,
        ].compactMap { $0 }
    }
    
    deinit{
        print("Pokemon detail correcly deinit")
    }
}
