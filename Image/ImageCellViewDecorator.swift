//
//  ImageCellViewDecorator.swift
//  Image
//
//  Created by Камиль Бакаев on 09.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
import UIKit
import CoreLogic

class MainQueueDecorator<View> {
    
    let imageCellView: View
    
    internal init(imageCellView: View) {
        self.imageCellView = imageCellView
    }
}

extension MainQueueDecorator: ImageCellView where View:ImageCellView, View.Image == UIImage {
    
    func display(model: CellImageViewModel<UIImage>) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async {
                self.imageCellView.display(model: model)
            }
        }
        
        self.imageCellView.display(model: model)
    }
}

extension MainQueueDecorator: ImageDataLoader where View == ImageDataLoader {
    func getImageData(with url: URL, completion: @escaping (Result<Data, Error>) -> ()) -> URLSessionDataTaskProtocol {
        let complition: (Result<Data, Error>) -> () = { result in
            guard Thread.isMainThread else {
                return DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            completion(result)
        }
        
        return imageCellView.getImageData(with: url, completion: complition)
    }
}

extension MainQueueDecorator: ImagesLoader where View == ImagesLoader {
    func getImages(with url: URL, completion: @escaping (Result<ImagesResult, Error>) -> ()) {
        let complition: (Result<ImagesResult, Error>) -> () = { result in
            guard Thread.isMainThread else {
                return DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            completion(result)
        }
        
        return imageCellView.getImages(with: url, completion: complition)
    }
    
    
}


