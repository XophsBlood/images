//
//  CellImageViewController.swift
//  Image
//
//  Created by Камиль Бакаев on 07.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
import UIKit
import CoreLogic

class ImagePictureModel {
    let croppedPicture: String
    let id: String
    
    internal init(croppedPicture: String, id: String) {
        self.croppedPicture = croppedPicture
        self.id = id
    }
}

protocol ImageCellView: AnyObject {
    associatedtype Image
    func display(model: CellImageViewModel<Image>)
}

class CellImageViewController {
    private var cell: ImageCollectionViewCell?
    let imageViewModel: ImageViewModel<UIImage>
    
    init(imageViewModel: ImageViewModel<UIImage>) {
        self.imageViewModel = imageViewModel
    }
    
    func createCell(collectionView: UICollectionView, indexPath: IndexPath) -> ImageCollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        self.cell = cell
        bind(cell: cell)
        imageViewModel.didStartDownloading()
        
        return cell
    }
    
    func prefetch() {
        imageViewModel.didStartDownloading()
    }
    
    func cancel() {
        imageViewModel.didCancelDownloading()
        cell = nil
    }
    
    func bind(cell: ImageCollectionViewCell) {
        cell.activityIndicator.startAnimating()
        self.cell?.newsTextLabel.text = imageViewModel.getImageModelId
        imageViewModel.didDownloaded = { [weak self] image in
            
            self?.cell?.newsImageView.image = image
        }
        
        imageViewModel.isDownloading = { [weak self] isDownloading in
            if isDownloading {
                self?.cell?.activityIndicator.startAnimating()
            } else {
                self?.cell?.activityIndicator.stopAnimating()
            }
            
        }
    }
}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
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
        let imageViewModel = CellImageViewModel<Image>(image: nil, text: self.myPicture.id, isLoading: true)
        isDownloading?(true)
        let url = URL(string: "\(myPicture.croppedPicture.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")!
        dataTask = dataLoader.getImageData(with: url) { result in
            switch result {
            case let .success(data):
                let image = self.closure(data)
                let imageViewModel = CellImageViewModel(image: image, text: self.myPicture.id, isLoading: false)
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

