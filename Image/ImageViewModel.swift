//
//  ImageViewPresenter.swift
//  Image
//
//  Created by Камиль Бакаев on 07.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
import CoreLogic

protocol ImageDataDownloader {
    func didStartDownloading()
    func didCancelDownloading()
}

class ImageViewModel<Image> {
    
    let dataLoader: ImageDataLoader
    private let myPicture: ImagePictureModel
    var dataTask: URLSessionDataTaskProtocol?
    let closure: (Data) -> Image
    var didDownloaded: ((Image) -> ())?
    var isDownloading: ((Bool) -> ())?
    
    var getImageModelId: String {
        return myPicture.id
    }
    
    internal init(dataLoader: ImageDataLoader, myPicture: ImagePictureModel, closure: @escaping (Data) -> Image) {
        self.dataLoader = dataLoader
        self.myPicture = myPicture
        self.closure = closure
    }
    
    func didStartDownloading() {
        isDownloading?(true)
        let url = URL(string: "\(myPicture.croppedPicture.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")!
        dataTask = dataLoader.getImageData(with: url) { result in
            switch result {
            case let .success(data):
                let image = self.closure(data)
                self.didDownloaded?(image)
            case let .failure(error):
                print(error)
            }
            self.isDownloading?(false)
        }
    }
    
    func didCancelDownloading() {
        dataTask?.cancel()
    }
}
