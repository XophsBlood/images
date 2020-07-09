//
//  ImageResultToControllerAdapter.swift
//  Image
//
//  Created by Камиль Бакаев on 07.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
import CoreLogic

class ImageResultToControllerAdapter<Image, View: ImageCellView>: ImageListView where Image == View.Image{
    let imageDataLoader: ImageDataLoader
    let viewController: ViewController
    let closure: (Data) -> Image
    
    init(imageDataLoader: ImageDataLoader, viewController: ViewController, closure: @escaping (Data) -> Image) {
        self.imageDataLoader = imageDataLoader
        self.viewController = viewController
        self.closure = closure
    }
    
    func display(images: [MyPicture]) {
        let controllers: [CellImageViewController] = images.map {
            let proxy: CellImageProxy<Image, AnyImageCellView> = CellImageProxy()
            let anyImageCellView = AnyImageCellView<Image>(proxy)
            let decorator = ImageCellViewDecorator<Image, AnyImageCellView>(imageCellView: anyImageCellView)
            let imageDataDownloader = ImageViewPresenter<Image, View>(dataLoader: imageDataLoader, myPicture: $0, imageCellView: decorator as! View, closure: closure)
            let cell = CellImageViewController(myPicture: $0, imageDataDownloader: imageDataDownloader)
            let anyController = AnyImageCellView(cell)
            proxy.imageCellView = anyImageCellView
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

class CellImageProxy<Image, View: ImageCellView>: ImageCellView where Image == View.Image {
    weak var imageCellView: View?
    
    func display(model: CellImageViewModel<Image>) {
        imageCellView?.display(model: model)
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
    
    func display(images: [MyPicture]) {
        
        guard Thread.isMainThread else {
            return DispatchQueue.main.async {
                self.imageListView.display(images: images)
            }        }
        
        self.imageListView.display(images: images)
    }
}




