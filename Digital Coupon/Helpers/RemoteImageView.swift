//
//  RemoteImageView.swift
//  Digital Coupon
//
//  Created by Joe Glass on 5/29/20.
//  Copyright © 2020 Joe Glass. All rights reserved.
//


import SwiftUI

struct RemoteImageView: View {
    
    let frameSize: CGFloat = 95
    
    
    @ObservedObject var imageLoader:ImageLoader
    
    @State var image: UIImage = UIImage()
    var circle: Bool = false
    
    init(withURL url:String, isCircle bool: Bool = false) {
        imageLoader = ImageLoader(urlString:url)
        self.circle  = bool
    }
    var body: some View {
        HStack{
            if circle{
            Image(uiImage: imageLoader.data != nil ? UIImage(data:imageLoader.data!)! : UIImage())
                .resizable()
                .background(Color.blue.opacity(0.0))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.blue, lineWidth: 0))
                .shadow(radius: 0)
                .frame(width: frameSize-50, height: frameSize-50)
            }else{
                Image(uiImage: imageLoader.data != nil ? UIImage(data:imageLoader.data!)! : UIImage())
                    .resizable()
                    .background(Color.white)
                    .clipShape(Rectangle())
                    .overlay(Rectangle().stroke(Color.blue, lineWidth: 1))
                    .shadow(radius: 0)
                    .padding()
                    .frame(width: frameSize, height: frameSize)
            }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var data:Data?

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

struct RemoteImageView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImageView(withURL: "")
    }
}
