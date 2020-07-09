//
//  CellImageViewModel.swift
//  Image
//
//  Created by Камиль Бакаев on 09.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

class CellImageViewModel<Image> {
    let image: Image?
    let text: String
    var isLoading = false
    
    internal init(image: Image?, text: String, isLoading: Bool) {
        self.image = image
        self.text = text
        self.isLoading = isLoading
    }
}
