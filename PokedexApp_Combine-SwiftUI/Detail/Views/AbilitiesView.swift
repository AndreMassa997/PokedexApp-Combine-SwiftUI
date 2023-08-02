//
//  AbilitiesView.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 02/08/23.
//

import SwiftUI

struct AbilitiesView: View {
    let abilities: [Ability]
    let color: Color
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.white)
            VStack{
                Text("Abilities")
                    .font(.system(size: 20)
                        .weight(.thin))
                    .foregroundColor(color)
                VStack{
                    ForEach(abilities, id: \.self) { ability in
                        VStack(alignment: .leading){
                            Text(ability.ability.name.capitalized)
                                .font(.system(size: 18)
                                    .weight(.light))
                                .foregroundColor(color)
                                .padding(.horizontal, 5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if ability != abilities.last{
                                Divider()
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
        }
        
    }
}
