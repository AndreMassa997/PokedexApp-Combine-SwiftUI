//
//  Network.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 01/08/23.
//

import Foundation
import Combine

func fetchPokemons(_ offsetToRequest: Int) -> some Publisher<MainModel, Error>{
    var components = URLComponents()
    components.scheme = "https"
    components.path = "pokeapi.co/api/v2/"
    components.path.append("pokemon")
    let queryItems: [URLQueryItem] = [
        URLQueryItem(name: "offset", value: String(offsetToRequest))
    ]
    components.queryItems = queryItems
    
    return URLSession.shared.dataTaskPublisher(for: components.url!)
            .map(\.data)
            .decode(type: MainModel.self, decoder: JSONDecoder())
}

func fetchPokemon(url: URL) -> some Publisher<PokemonModel, Error>{
    URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: PokemonModel.self, decoder: JSONDecoder())
}

func fetchPokemonByNameOrId(_ nameOrId: String) -> some Publisher<PokemonModel, Error>{
    var components = URLComponents()
    components.scheme = "https"
    components.path = "pokeapi.co/api/v2/pokemon/"
    components.path.append(nameOrId)
    
    return URLSession.shared.dataTaskPublisher(for: components.url!)
        .map(\.data)
        .decode(type: PokemonModel.self, decoder: JSONDecoder())
}
