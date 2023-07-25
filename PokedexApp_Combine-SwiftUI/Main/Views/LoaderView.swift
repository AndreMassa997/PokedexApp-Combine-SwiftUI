//
//  LoaderView.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 24/07/23.
//

import SwiftUI

struct LoaderView: View {
    
    @State var isAnimating: Bool = false
    
    private var animation: Animation {
            Animation.linear(duration: 0.5)
                .repeatForever(autoreverses: false)
        }
    
    var body: some View {
        ZStack{
            Image("pokeball")
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
                .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                .animation(animation, value: self.isAnimating)
                .onAppear{
                    DispatchQueue.main.async {
                        self.isAnimating = true
                    }
                }
                .onDisappear{
                    self.isAnimating = false
                }
        }
        
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}
