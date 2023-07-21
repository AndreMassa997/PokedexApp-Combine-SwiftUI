//
//  PokemonCell.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 21/07/23.
//

import SwiftUI

struct PokemonCell: View {
    
    let pokemon: PokemonModel
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))
                .foregroundColor(Color(uiColor: pokemon.types?.first?.type.name.mainColor ?? .black))
            VStack{
                CachedAsyncImage(url: (pokemon.sprites?.other?.officialArtwork?.frontDefault ?? pokemon.sprites?.frontDefault) ?? URL(fileURLWithPath: "")){ phase in
                    switch phase{
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 100)
                        case .empty:
                        ProgressView()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                    case .failure(_):
                        EmptyView()
                            .frame(height: 100)
                    @unknown default:
                        EmptyView()
                            .frame(height: 100)
                    }
                }
                 
                Text(pokemon.name.capitalized)
                    .font(
                        .system(size: 18)
                        .weight(.black))
                    .foregroundColor(.white)
                Text(String.init(format: "#%03d", pokemon.id))
                    .font(
                        .system(size: 10)
                        .weight(.light))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
        }
    }
}
