//
//  MainViewModel.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 21/07/23.
//

import Combine
import Foundation

class MainViewModel: ObservableObject {
    
    private var offsetToRequest: Int = 0
    @Published var pokemons = [PokemonModel]()
    private var cancellables = [AnyCancellable]()
    
    @Published var searchText = ""
    
    init(){
        $searchText
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .compactMap({ $0 })
            .sink(receiveValue: { [weak self] searchField in
                guard let self = self else { return }
                if searchField.isEmpty{
                    self.fetchPokemons()
                }else{
                    self.searchPokemon(nameOrId: searchField)
                        .sink(receiveCompletion: { _ in }, receiveValue: { foundedPokemons in
                            self.pokemons = foundedPokemons
                        })
                        .store(in: &self.cancellables)
                }
            })
            .store(in: &cancellables)
    }
        
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
                                    var tmpPokemons = self.pokemons
                                    tmpPokemons.append(pokemon)
                                    tmpPokemons.sort(by: { $0.id < $1.id })
                                    self.pokemons = tmpPokemons
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
    
    private func fetchPokemonByNameOrId(_ nameOrId: String) -> Future<PokemonModel, Error>{
        return Future<PokemonModel, Error>{ [weak self] promise in
            guard let self = self else { return }
            var components = URLComponents()
            components.scheme = "https"
            components.path = "pokeapi.co/api/v2/pokemon/"
            components.path.append(nameOrId)
            
            guard let url = components.url else {
                print("Unable to compose URL")
                return
            }
            
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
    
    private func searchPokemon(nameOrId: String) -> Future<[PokemonModel], Error>{
        return Future<[PokemonModel], Error>{ [weak self] promise in
            guard let self = self else { return }
            let filteredPokemons = self.pokemons.filter { pokemon in
                if let id = Int(nameOrId){
                    return pokemon.id == id
                }
                //otherwise search by name
                return pokemon.name.lowercased().contains(nameOrId.lowercased())
            }
            if !filteredPokemons.isEmpty{
                promise(.success(filteredPokemons))
            }else{
                self.fetchPokemonByNameOrId(nameOrId)
                    .sink(receiveCompletion: { _ in }, receiveValue: { foundedPokemon in
                        promise(.success([foundedPokemon]))
                    })
                    .store(in: &self.cancellables)
                
            }
        }
    }
    
}
