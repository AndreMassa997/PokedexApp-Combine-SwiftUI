//
//  ChipsView.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 02/08/23.
//

import SwiftUI

struct ChipsView: View {
    let types: [PokemonType]
    var groupedItems: [[PokemonType]] = []
    let screenWidth = UIScreen.main.bounds.width
    
    init(types: [PokemonType]) {
        self.types = types
        self.groupedItems = createGroupedItems(types)
    }
    
    private func createGroupedItems(_ items: [PokemonType]) -> [[PokemonType]]{
        var groupedItems: [[PokemonType]] = [[PokemonType]]()
        var tempItems: [PokemonType] = [PokemonType]()
        var width: CGFloat = 0
        
        for item in items{
            let label = UILabel()
            label.text = item.rawValue.uppercased()
            label.sizeToFit()
            
            let labelWidth = label.frame.size.width + 32
            
            if (width + labelWidth + 55) < screenWidth {
                width += labelWidth
                tempItems.append(item)
            } else {
                width = labelWidth
                groupedItems.append(tempItems)
                tempItems.removeAll()
                tempItems.append(item)
            }
        }
        groupedItems.append(tempItems)
        return groupedItems
    }
        
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.white)
            VStack{
                ForEach(groupedItems, id: \.self){ subItems in
                    HStack{
                        ForEach(subItems, id: \.self){ type in
                            HStack(spacing: 10){
                                HStack(spacing: 5){
                                    Image(type.rawValue)
                                    Text(type.rawValue.uppercased())
                                        .font(.system(size: 12)
                                            .weight(.bold))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                }
                            }
                            .frame(width: 110, height: 30)
                            .background(Color(type.mainColor))
                            .cornerRadius(20)
                            .shadow(color: Color(type.mainColor), radius: 5)
                        }
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
            }
        }
        
    }
}
