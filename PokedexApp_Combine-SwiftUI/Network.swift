//
//  Network.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 01/08/23.
//

import Foundation
import Combine

func fetchPokemons(_ offsetToRequest: Int) async throws -> MainModel {
    var components = URLComponents()
    components.scheme = "https"
    components.path = "pokeapi.co/api/v2/"
    components.path.append("pokemon")
    let queryItems: [URLQueryItem] = [
        URLQueryItem(name: "offset", value: String(offsetToRequest))
    ]
    components.queryItems = queryItems
    
    guard let url = components.url else {
        throw NetworkError.invalidURL
    }
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.invalidResponse }
    
    do{
        let decoder = JSONDecoder()
        return try decoder.decode(MainModel.self, from: data)
    } catch{
        throw NetworkError.invalidData
    }
}

func fetchPokemon(url: URL) async throws -> PokemonModel{
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.invalidResponse }
    
    do{
        let decoder = JSONDecoder()
        return try decoder.decode(PokemonModel.self, from: data)
    } catch{
        throw NetworkError.invalidData
    }
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

enum NetworkError: Error{
    case invalidURL
    case invalidResponse
    case invalidData
}
