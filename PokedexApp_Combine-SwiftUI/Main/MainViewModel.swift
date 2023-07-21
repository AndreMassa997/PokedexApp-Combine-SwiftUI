//
//  MainViewModel.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 21/07/23.
//

import Combine
import Foundation

class MainViewModel: ObservableObject {
    
    @Published var offsetToRequest: Int = 0
    @Published var pokemons = [PokemonModel]()
    private var cancellables = [AnyCancellable]()
        
    func fetchPokemons(){
        var components = URLComponents()
        components.scheme = "https"
        components.path = "pokeapi.co/api/v2/"
        components.path.append("pokemon")
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "offset", value: String(offsetToRequest))
        ]
        components.queryItems = queryItems
        
        if let url = components.url{
            URLSession.shared.dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .map(\.data)
                .decode(type: MainModel.self, decoder: JSONDecoder())
                .sink(receiveCompletion: { res in
                    
                }, receiveValue: { [weak self] mainModel in
                    guard let self = self else { return }
                    if let nextUrl = mainModel.next, let nextOffsetString = nextUrl.getQueryStringParameter(param: "offset"), let nextOffset = Int(nextOffsetString){
                        self.offsetToRequest = nextOffset
                        mainModel.results?.forEach{ result in
                            guard let url = result.url else { return }
                            self.fetchPokemon(url: url)
                                .sink(receiveCompletion: { _ in
                                    
                                }, receiveValue: { pokemon in
                                    self.pokemons.append(pokemon)
                                })
                                .store(in: &self.cancellables)
                        }
                    }
                })
                .store(in: &cancellables)
        }
    }
    
    private func fetchPokemon(url: URL) -> Future<PokemonModel, Error>{
        return Future<PokemonModel, Error>{ [weak self] promise in
            guard let self = self else { return }
            URLSession.shared.dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .map(\.data)
                .decode(type: PokemonModel.self, decoder: JSONDecoder())
                .sink(receiveCompletion: { res in
                    if case let .failure(error) = res{
                        promise(.failure(error))
                    }
                }, receiveValue: { pokemonModel in
                    promise(.success(pokemonModel))
                })
                .store(in: &self.cancellables)
        }
       
    }
    
}
