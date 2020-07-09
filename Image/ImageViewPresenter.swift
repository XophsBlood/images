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

class ImageViewPresenter<Image, View: ImageCellView>: ImageDataDownloader where Image == View.Image {
    
    let dataLoader: ImageDataLoader
    let myPicture: ImagePictureModel
    let imageCellView: View
    var dataTask: URLSessionDataTaskProtocol?
    let closure: (Data) -> Image
    
    internal init(dataLoader: ImageDataLoader, myPicture: ImagePictureModel, imageCellView: View, closure: @escaping (Data) -> Image) {
        self.dataLoader = dataLoader
        self.myPicture = myPicture
        self.imageCellView = imageCellView
        self.closure = closure
    }
    
    func didStartDownloading() {
        let imageViewModel = CellImageViewModel<Image>(image: nil, text: self.myPicture.id, isLoading: true)
        imageCellView.display(model: imageViewModel)
        let url = URL(string: "\(myPicture.croppedPicture.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")!
        dataTask = dataLoader.getImageData(with: url) { result in
            switch result {
            case let .success(data):
                let image = self.closure(data)
                let imageViewModel = CellImageViewModel(image: image, text: self.myPicture.id, isLoading: false)
                self.imageCellView.display(model: imageViewModel)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func didCancelDownloading() {
        dataTask?.cancel()
    }
}

extension MainQueueDecorator: ImageDataDownloader where View: ImageDataDownloader {
    func didStartDownloading() {
        imageCellView.didStartDownloading()
    }
    
    func didCancelDownloading() {
        imageCellView.didCancelDownloading()
    }
    
    
}
