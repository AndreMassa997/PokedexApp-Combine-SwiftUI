//
//  StatsView.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 02/08/23.
//

import SwiftUI

struct StatsView: View {
    let stats: [Stats]
    let color: Color
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.white)
            VStack{
                Text("Stats")
                    .font(.system(size: 20)
                        .weight(.thin))
                    .foregroundColor(color)
                ForEach(stats, id: \.self) { stat in
                    StatView(stat: stat, color: color)
                }.padding(.vertical, 5)
                .padding(.horizontal, 10)
            }
        }
    }
}

struct StatView: View{
    let stat: Stats
    let statName : String
    let statValue: String
    let progressValue: Float
    let color: Color
    
    init(stat: Stats, color: Color) {
        self.stat = stat
        self.statName = stat.stat.name.name
        
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 3
        self.statValue = formatter.string(from: NSNumber(value: stat.baseStat ?? 0)) ?? ""
        
        self.progressValue = Float(stat.baseStat ?? 0)/stat.stat.name.maxValue
        self.color = color
    }
    
    var body: some View{
        HStack{
            Text(statName.uppercased())
                .font(.system(size: 12)
                    .weight(.heavy))
                .foregroundColor(color)
                .frame(width: 40)
            Spacer()
            Text(statValue)
                .font(.system(size: 14)
                    .weight(.thin))
                .frame(width: 30)
            Spacer()
            ProgressView(value: progressValue)
                .progressViewStyle(.linear)
                .tint(color)
            
        }
    }
}
