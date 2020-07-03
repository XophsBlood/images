//
//  ImageUIComposer.swift
//  Image
//
//  Created by Камиль Бакаев on 03.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
import CoreLogic
import UIKit

class ImageUIComposer {
    static func makeViewController() -> ViewController {
        let session = URLSession(configuration: .default)
        let imageViewController = ImageCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let networkManager = NetworkManager(session: session)
        let tokenLoader = HTTPTokenLoader(httpCLient: networkManager)
        let authClient = AuthHTTPClient(networkManager: networkManager, tokenLoader: tokenLoader)
        let imagesLoader = HTTPImagesLoader(httpCLient: authClient)
        imageViewController.imageViewControllerDelegate = ImageFetcher(imagesLoader: imagesLoader, imageListView: imageViewController)
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateInitialViewController() as! ViewController
        viewController.collectionViewController = imageViewController
        
        
        return viewController
    }
}
