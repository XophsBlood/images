//
//  StubImageDataLoader.swift
//  ImageUIUnitTests
//
//  Created by Камиль Бакаев on 06.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
import CoreLogic

class StubImageDataLoader: ImageDataLoader {
    
    var count: Int = 0
    
    var arrayCompl: [(url: URL, complition: (Result<Data, Error>) -> ())] = []
    
    var downloadedUrls: [URL] {
        return arrayCompl.map { $0.url }
    }
    
    func getImageData(with url: URL, completion: @escaping (Result<Data, Error>) -> ()) -> URLSessionDataTaskProtocol?{
        count += 1
        arrayCompl.append((url, completion))
        return MockURLSessionDataTask()
    }
    
    func finishDownload(at index: Int, with result: Result<Data, Error>) {
        
        arrayCompl[index].complition(result)
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func cancel() {
        
    }
    
    private (set) var counter = 0
    func resume() {
        counter += 1
    }
}
