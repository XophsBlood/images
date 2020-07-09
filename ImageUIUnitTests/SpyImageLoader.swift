//
//  SpyImageLoader.swift
//  ImageUIUnitTests
//
//  Created by Камиль Бакаев on 06.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
import CoreLogic

class SpyImageLoader: ImagesLoader {
    var count: Int = 0
    
    var arrayCompl: [(Result<ImagesResult, Error>) -> ()] = []
    
    func getImages(with url: URL, completion: @escaping (Result<ImagesResult, Error>) -> ()) {
        count += 1
        arrayCompl.append(completion)
    }
    
    func finish(with imageResult: Result<ImagesResult, Error>, at index: Int) {
        arrayCompl[index](imageResult)
    }
}
