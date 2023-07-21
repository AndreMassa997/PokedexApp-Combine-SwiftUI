//
//  MainModel.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 21/07/23.
//

import Foundation

//Pokemons API Model
// MARK: - MainModel
struct MainModel: Decodable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [ResultModel]?
}

// MARK: - ResultModel
struct ResultModel: Decodable {
    let name: String?
    let url: URL?
}
