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
    let name: String
    let id: String
    
    var body: some View {
        ZStack{
            RoundedCornersShape(corners: [.topRight, .topLeft], radius: 40)
                .fill(.white)
                .padding(.top, 120)
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
                            }
                            .frame(width: 200, height: 200)
                    }
                }.tabViewStyle(PageTabViewStyle())
                
                Text(name.capitalized)
                    .font(
                        .system(size: 30)
                        .weight(.light))
                    .foregroundColor(.black)
                Text(id)
                    .font(
                        .system(size: 14)
                        .weight(.thin))
                    .foregroundColor(.black)
            }
            .onAppear{
                setupAppearance()
            }
        }
        
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = color
    }
}

struct PageControl: UIViewRepresentable{
    
    var current: Int = 0
    
    func makeUIView(context: UIViewRepresentableContext<PageControl>) -> UIPageControl {
        let page = UIPageControl()
        return page
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = current
    }
    
}

struct RoundedCornersShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
