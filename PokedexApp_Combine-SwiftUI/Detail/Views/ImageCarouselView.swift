//
//  ImageCarouselView.swift
//  PokedexApp_Combine-SwiftUI
//
//  Created by Andrea Massari on 01/08/23.
//

import SwiftUI

struct ImageCarouselView: View {
    
    let imagesUrl: [URL]
    let color: UIColor
    
    var body: some View {
        VStack{
            TabView{
                ForEach(imagesUrl, id: \.self){ url in
                        CachedAsyncImage(url: url){ phase in
                            switch phase{
                                case .success(let image):
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                case .empty:
                                    ProgressView()
                                    .aspectRatio(contentMode: .fit)
                                case .failure(_):
                                    EmptyView()
                                @unknown default:
                                    EmptyView()
                            }
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                    
                }
            }.tabViewStyle(PageTabViewStyle())
        }
        .onAppear{
            setupAppearance()
        }
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = color
    }
}

struct ImageCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCarouselView(imagesUrl: [], color: .clear)
    }
}
