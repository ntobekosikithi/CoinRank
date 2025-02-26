//
//  ImageCache.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/24.
//

import SwiftUI
import Combine
import WebKit

//MARK:  Main View Component for Cached Images
struct LoadImage: View {
    let url: String
    let placeholder: Image
    
    @StateObject private var cachedImage = CachedImage()
    
    init(url: String, placeholder: Image = Image(systemName: "photo")) {
        self.url = url
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = cachedImage.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if let svgData = cachedImage.svgData {
                SVGWebView(svgData: svgData)
            } else if cachedImage.hasError {
                placeholder
            } else {
                placeholder
            }
        }
        .onAppear { cachedImage.load(from: url) }
    }
}

//MARK: SVG Renderer using WKWebView
struct SVGWebView: UIViewRepresentable {
    let svgData: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.scrollView.isScrollEnabled = false
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
        body { margin: 0; display: flex; justify-content: center; align-items: center; background: transparent; }
        svg { width: 100%; height: 100%; }
        </style>
        </head>
        <body>\(svgData)</body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
}

//MARK: Image Loader with SVG Support
class CachedImage: ObservableObject {
    @Published var image: UIImage?
    @Published var svgData: String?
    @Published var hasError = false
    
    private var cancellable: AnyCancellable?
    private static let cache = NSCache<NSString, UIImage>()
    
    func load(from urlString: String) {
        image = nil
        svgData = nil
        hasError = false
        
        let cacheKey = urlString as NSString
        if let cachedImage = Self.cache.object(forKey: cacheKey) {
            image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {
            hasError = true
            return
        }

        if url.pathExtension.lowercased() == "svg" {
            fetchSVG(from: url)
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response -> UIImage? in
                if response.mimeType?.contains("svg") == true || String(data: data, encoding: .utf8)?.contains("<svg") == true {
                    self.fetchSVG(from: url)
                    return nil
                }
                if let image = UIImage(data: data) {
                    Self.cache.setObject(image, forKey: cacheKey)
                    return image
                }
                return nil
            }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.image = $0
                self?.hasError = $0 == nil && self?.svgData == nil
            }
    }
    
    private func fetchSVG(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let svgString = String(data: data, encoding: .utf8) else { return }
            
            DispatchQueue.main.async {
                self.svgData = svgString
            }
        }.resume()
    }
}
