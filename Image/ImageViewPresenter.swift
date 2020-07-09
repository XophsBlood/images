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
    let myPicture: MyPicture
    let imageCellView: View
    var dataTask: URLSessionDataTaskProtocol?
    let closure: (Data) -> Image
    
    internal init(dataLoader: ImageDataLoader, myPicture: MyPicture, imageCellView: View, closure: @escaping (Data) -> Image) {
        self.dataLoader = dataLoader
        self.myPicture = myPicture
        self.imageCellView = imageCellView
        self.closure = closure
    }
    
    func didStartDownloading() {
        let imageViewModel = CellImageViewModel<Image>(image: nil, text: self.myPicture.id, isLoading: true)
        imageCellView.display(model: imageViewModel)
        let url = URL(string: "\(myPicture.croppedPictrure.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")!
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


class ImageCellViewDecorator<Image, View: ImageCellView>: ImageCellView where Image == View.Image {
    
    let imageCellView: View
    
    internal init(imageCellView: View) {
        self.imageCellView = imageCellView
    }
    
    func display(model: CellImageViewModel<Image>) {
        
        guard Thread.isMainThread else {
            return DispatchQueue.main.async {
                self.imageCellView.display(model: model)
            }
        }
        
        self.imageCellView.display(model: model)
    }
}
