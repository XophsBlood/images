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


