//
//  ImageCellViewDecorator.swift
//  Image
//
//  Created by Камиль Бакаев on 09.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
import UIKit

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



