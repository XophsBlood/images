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

class ImageFetcher: ImageViewControllerDelegate {
    
    let imagesLoader: ImagesLoader
    let imageListView: ImageListView
    let url = URL(string: "http://195.39.233.28:8035/images")!
    var pageCount = 0
    var images: [MyPicture] = []
    
    internal init(imagesLoader: ImagesLoader, imageListView: ImageListView) {
        self.imageListView = imageListView
        self.imagesLoader = imagesLoader
    }
    
    func fetchImages() {
        pageCount += 1
        imagesLoader.getImages(with: url) { result in
            switch result {
            case let .success(imagesResult):
                self.images.append(contentsOf: imagesResult.pictures)
                let models = self.images.map {
                    ImagePictureModel(croppedPicture: $0.croppedPictrure, id: $0.id)
                }
                self.imageListView.display(images: models)
            case let .failure(error):
                print(error)
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
                self.imageListView.display(images: models)
            case let .failure(error):
                print(error)
            }
        }
    }
}
