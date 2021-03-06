//
//  ImageFetcher.swift
//  Image
//
//  Created by Камиль Бакаев on 03.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
import CoreLogic

protocol ImageViewControllerDelegate {
    func fetchImages()
    func nextFetch()
}

class ImagesViewModel<Image>: ImageViewControllerDelegate {
    
    let imagesLoader: ImagesLoader
    var imageListView: ModelsToControllerAdapter
    let url = URL(string: "http://195.39.233.28:8035/images")!
    var pageCount = 0
    private var images: [MyPicture] = []
    var didDownloaded: (([CellImageViewController]) -> ())?
    
    
    internal init(imagesLoader: ImagesLoader, imageListView: ModelsToControllerAdapter) {
        self.imageListView = imageListView
        self.imagesLoader = imagesLoader
    }
    
    func fetchImages() {
        print(url.scheme)
        pageCount += 1
        imagesLoader.getImages(with: url) { result in
            switch result {
            case let .success(imagesResult):
                self.images.append(contentsOf: imagesResult.pictures)
                let models = self.images.map {
                    ImagePictureModel(croppedPicture: $0.croppedPictrure, id: $0.id)
                }
                
                self.didDownloaded?(self.imageListView.adaptToControllers(images: models))
            case let .failure(error):
                break
            }
        }
    }
    
    
    
    @objc func nextFetch() {
        pageCount += 1
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "page", value: "\(pageCount)")]
        imagesLoader.getImages(with: (urlComponents?.url)!) { result in
            switch result {
            case let .success(imagesResult):
                self.images.append(contentsOf: imagesResult.pictures)
                let models = self.images.map {
                    ImagePictureModel(croppedPicture: $0.croppedPictrure, id: $0.id)
                }
                self.didDownloaded?(self.imageListView.adaptToControllers(images: models))
            case let .failure(error):
                print(error)
            }
        }
    }
}
