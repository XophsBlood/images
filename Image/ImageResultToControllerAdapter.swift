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

class ImageResultToControllerAdapter<Image>: ImageListView {
    let imageDataLoader: ImageDataLoader
    let viewController: ViewController
    let closure: (Data) -> UIImage
    
    init(imageDataLoader: ImageDataLoader, viewController: ViewController, closure: @escaping (Data) -> UIImage) {
        self.imageDataLoader = imageDataLoader
        self.viewController = viewController
        self.closure = closure
    }
    
    func display(images: [ImagePictureModel]) {
        let controllers: [CellImageViewController] = images.map {
            let proxy = WeakProxy<CellImageViewController>()
            let mainQueueProxy = MainQueueDecorator(imageCellView: proxy)
            let mainQueueLoader = MainQueueDecorator(imageCellView: imageDataLoader)
            let imageDataDownloader = ImageViewModel<UIImage>(dataLoader: mainQueueLoader, myPicture: $0, closure: closure)
    
            let cell = CellImageViewController(imageViewModel: imageDataDownloader)
            proxy.object = cell
            
            return cell
        }
        viewController.collectionViewController.displayControllers(controllers: controllers)
    }
}

private class _AnyImageCellViewBox<Image>: ImageCellView {
    func display(model: CellImageViewModel<Image>) {
        fatalError()
    }
}

private class _ImageCellViewBox<Base: ImageCellView>:
_AnyImageCellViewBox<Base.Image> {
    private let _base: Base
    init(_ base: Base) {
        _base = base
    }
    override func display(model: CellImageViewModel<Image>) {
        _base.display(model: model)
    }
}

class AnyImageCellView<Image>: ImageCellView {
   private let _box: _AnyImageCellViewBox<Image>
    
   init<ImageCellViewType: ImageCellView>(_ mapper: ImageCellViewType)
      where ImageCellViewType.Image == Image {
      _box = _ImageCellViewBox(mapper)
   }
    
    func display(model: CellImageViewModel<Image>) {
        _box.display(model: model)
    }
}

class ImageListViewDecorator: ImageListView {
    
    let imageListView: ImageListView
    
    internal init(imageListView: ImageListView) {
        self.imageListView = imageListView
    }
    
    func display(images: [ImagePictureModel]) {
        
        guard Thread.isMainThread else {
            return DispatchQueue.main.async {
                self.imageListView.display(images: images)
            }        }
        
        self.imageListView.display(images: images)
    }
}




