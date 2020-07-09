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

class CellImageViewController: ImageCellView {
    private var cell: ImageCollectionViewCell?
    let imageViewPresenter: ImageDataDownloader
    let myPicture: ImagePictureModel?
    
    init(myPicture: ImagePictureModel, imageDataDownloader: ImageDataDownloader) {
        self.myPicture = myPicture
        self.imageViewPresenter = imageDataDownloader
    }
    
    func createCell(collectionView: UICollectionView, indexPath: IndexPath) -> ImageCollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        self.cell = cell
        imageViewPresenter.didStartDownloading()
        return cell
    }
    
    func display(model: CellImageViewModel<UIImage>) {
        if let image = model.image {
            cell?.newsImageView.image = image
        }
        if model.isLoading {
            cell?.activityIndicator.startAnimating()
        } else {
            cell?.activityIndicator.stopAnimating()
        }
        cell?.newsTextLabel.text = model.text
    }
    
    func prefetch() {
        imageViewPresenter.didStartDownloading()
    }
    
    func cancel() {
        imageViewPresenter.didCancelDownloading()
        cell = nil
    }
}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
}
