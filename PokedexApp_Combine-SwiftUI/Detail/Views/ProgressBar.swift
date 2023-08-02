//
//  ProgressBar.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 02/08/23.
//

import SwiftUI

struct ProgressBar: View {
    var value: Float
    var color: Color
    
    @State var width: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width , height: geometry.size.height)
                    .foregroundColor(Color.black.opacity(0.1))
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color.black.opacity(0.1)))

                Rectangle()
                    .frame(width: width, height: geometry.size.height)
                    .foregroundColor(color)
                    .cornerRadius(5)
                    .animation(.linear, value: value)
                    .onAppear{
                        withAnimation(.linear(duration: 1)){
                            width = CGFloat(self.value)*geometry.size.width
                        }
                    }
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
        .frame(height: 5)
    }
}
