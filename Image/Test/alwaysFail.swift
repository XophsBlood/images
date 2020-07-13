//
//  alwaysFail.swift
//  Image
//
//  Created by Камиль Бакаев on 13.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
import CoreLogic

class AlwaysFail: ImagesLoader {
    func getImages(with url: URL, completion: @escaping (Result<ImagesResult, Error>) -> ()) {
        completion(.failure(NSError()))
    }
    
    
}
