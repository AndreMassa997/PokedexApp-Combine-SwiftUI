//
//  MainViewModel.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 21/07/23.
//

import Combine
import Foundation

class MainViewModel: ObservableObject {
    
    @Published var allPokemons = [PokemonModel]()
    @Published var searchedPokemons = [PokemonModel]()
    
    @Published var isLoading: Bool = false
    
    @Published var searchText = ""
    
    var pokemons: [PokemonModel]{
        if searchText.isEmpty{
            return allPokemons
        }else{
            return searchedPokemons
        }
    }
    
    private var offsetToRequest: Int = 0
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        $searchText
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .map{ text in
                self.searchPokemon(nameOrId: text)
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .assign(to: &$searchedPokemons)
    }
    
    func resetReasearch(){
        self.searchText = ""
    }
        
    func getPokemons(){
        self.isLoading = true
        fetchPokemons(offsetToRequest)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] mainModel in
                guard let self = self else { return }
                if let nextUrl = mainModel.next, let nextOffsetString = nextUrl.getQueryStringParameter(param: "offset"), let nextOffset = Int(nextOffsetString){
                    self.offsetToRequest = nextOffset
                    mainModel.results?.forEach{ result in
                        guard let url = result.url else { return }
                        fetchPokemon(url: url)
                            .receive(on: DispatchQueue.main)
                            .sink(receiveCompletion: { _ in }, receiveValue: { pokemon in
                                var tmpPokemons = self.allPokemons
                                tmpPokemons.append(pokemon)
                                tmpPokemons.sort(by: { $0.id < $1.id })
                                self.allPokemons = tmpPokemons
                                self.isLoading = false
                            })
                            .store(in: &self.cancellables)
                    }
                }
            }).store(in: &cancellables)
    }
    
    private func searchPokemon(nameOrId: String) -> some Publisher<[PokemonModel], Never>{
        let filteredPokemons = self.allPokemons.filter { pokemon in
            if let id = Int(nameOrId){
                return pokemon.id == id
            }
            //otherwise search by name
            return pokemon.name.lowercased().contains(nameOrId.lowercased())
        }
        if !filteredPokemons.isEmpty{
            return Just(filteredPokemons)
                .eraseToAnyPublisher()
        }else{
            return fetchPokemonByNameOrId(nameOrId.lowercased())
                .map({ [$0] })
                .replaceError(with: [])
                .eraseToAnyPublisher()
        }
    }
    
}
