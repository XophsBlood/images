//
//  ImageResultToControllerAdapter.swift
//  Image
//
//  Created by Камиль Бакаев on 07.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
import CoreLogic
import UIKit

class ImageResultToControllerAdapter<Image>: ModelsToControllerAdapter {
    let imageDataLoader: ImageDataLoader
    let viewController: ViewController
    let closure: (Data) -> UIImage
    
    init(imageDataLoader: ImageDataLoader, viewController: ViewController, closure: @escaping (Data) -> UIImage) {
        self.imageDataLoader = imageDataLoader
        self.viewController = viewController
        self.closure = closure
    }
    
    func adaptToControllers(images: [ImagePictureModel]) -> ([CellImageViewController]) {
        let controllers: [CellImageViewController] = images.map {
            let proxy = WeakProxy<CellImageViewController>()
            let mainQueueLoader = MainQueueDecorator(imageCellView: imageDataLoader)
            let imageDataDownloader = ImageViewModel<UIImage>(dataLoader: mainQueueLoader, myPicture: $0, closure: closure)
    
            let cell = CellImageViewController(imageViewModel: imageDataDownloader)
            proxy.object = cell
            
            return cell
        }
        return controllers
    }
}






