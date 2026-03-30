//
//  ImageCache.swift
//  MyWeather
//
//  Created by Prasad Kukkala on 2/20/26.
//

import Foundation
import SwiftUI

actor ImageCache {
    var cache: [URL: UIImage] = [:]
    
    func image(for url: URL) async -> UIImage? {
        if let cached = cache[url] {
            return cached
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let uiImage = UIImage(data: data) else {
                return nil
            }
            cache[url] = uiImage
            return uiImage
        } catch {
            return nil
        }
    }
}

struct AsyncImageView: View {
    let imagecache = ImageCache()
    let imageName: String
    @State var image: UIImage? = nil
    
    init(imageName: String) {
        self.imageName = imageName
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .task {
            guard let url = URL(string: "https://openweathermap.org/img/wn/\(self.imageName)@2x.png") else {
                return
            }
            image = await imagecache.image(for: url)
        }
    }
}
