//
//  ImageUIComposer.swift
//  Image
//
//  Created by Камиль Бакаев on 03.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
import CoreLogic
import UIKit

class ImageUIComposer {
    static func makeViewController(imagesLoader: ImagesLoader, imageDataLoader: ImageDataLoader) -> ViewController {
        let imageViewController = ImageCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateInitialViewController() as! ViewController
        let imageAdapter = ImageResultToControllerAdapter<UIImage> (imageDataLoader: imageDataLoader, viewController: viewController) { data in
            UIImage(data: data)!
        }
        let decorator = ImageListViewDecorator(imageListView: imageAdapter)
        imageViewController.imageViewControllerDelegate = ImageFetcher(imagesLoader: imagesLoader, imageListView: decorator)
        viewController.collectionViewController = imageViewController
        
        return viewController
    }
}
