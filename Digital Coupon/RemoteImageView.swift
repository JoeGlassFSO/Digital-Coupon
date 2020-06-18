//
//  RemoteImageView.swift
//  Digital Coupon
//
//  Created by Mac on 19/06/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import SwiftUI

struct RemoteImageView: View {
      let frameSize: CGFloat = 95
    
    @ObservedObject var imageLoader:ImageLoader
    
    @State var image:UIImage = UIImage()
    
    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }
    var body: some View {
        HStack{
            
            Image(uiImage: imageLoader.data != nil ? UIImage(data:imageLoader.data!)! : UIImage())
                .resizable()
                .clipShape(Rectangle())
                .background(Color.white)
                .overlay(Rectangle().stroke(Color.blue, lineWidth: 1))
                .shadow(radius: 0)
                .padding()
                .frame(width: frameSize, height: frameSize)
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
