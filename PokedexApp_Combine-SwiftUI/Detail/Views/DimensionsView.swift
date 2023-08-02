//
//  DimensionsView.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 02/08/23.
//

import SwiftUI

struct DimensionsView: View {
    
    let weight: Float
    let height: Float
    let color: Color
    
    //get the maximum values of height (20m) and weight (1000kg) in https://pokemondb.net/pokedex/stats/height-weight
    let maxHeight: Float = 20
    let maxWeight: Float = 1000
    
    let weightProgress: Float
    let heightProgress: Float
    
    init(weight: Float, height: Float, color: UIColor) {
        self.weight = weight
        self.height = height
        self.color = Color(color)
        weightProgress = self.weight/1000
        heightProgress = self.height/20
    }
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.white)
            VStack{
                Text("Dimensions")
                    .font(.system(size: 20)
                        .weight(.thin))
                    .foregroundColor(color)
                
                HStack{
                    DimensionView(value: "\(weight, specifier: "%.2f") Kg", title: "Weight", color: color, progress: weightProgress)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                    Divider()
                        .tint(.black.opacity(0.2))
                    DimensionView(value: "\(height, specifier: "%.2f") m", title: "Height", color: color, progress: heightProgress)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                }
                .frame(height: 100)
            }
            .padding(.vertical, 10)
        }
    }
}

struct DimensionView: View{
    let value: LocalizedStringKey
    let title: String
    let color: Color
    let progress: Float
    
    var body: some View{
        VStack{
            Text(title)
                .font(.system(size: 16)
                    .weight(.thin))
            Spacer()
            Text(value)
                .font(.system(size: 18)
                    .weight(.heavy))
                .foregroundColor(color)
            Spacer()
            ProgressBar(value: progress, color: color)
                .frame(height: 3)
        }
    }
}

struct DimensionsView_Previews: PreviewProvider {
    static var previews: some View {
        DimensionsView(weight: 0, height: 0, color: .white)
    }
}
