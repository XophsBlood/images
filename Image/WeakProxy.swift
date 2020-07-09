//
//  WeakProxy.swift
//  Image
//
//  Created by Камиль Бакаев on 09.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
import UIKit

class WeakProxy<Object: AnyObject> {
    internal weak var object: Object?
    
    init() {
    }
    
    init(_ object: Object) {
        self.object = object
    }
}

extension WeakProxy: ImageCellView where Object: ImageCellView, Object.Image == UIImage {
    func display(model: CellImageViewModel<UIImage>) {
        object?.display(model: model)
    }
}
