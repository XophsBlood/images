//
//  ImageUIUnitTests.swift
//  ImageUIUnitTests
//
//  Created by Камиль Бакаев on 06.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import XCTest
import CoreLogic
@testable import Image

class ImageUIUnitTests: XCTestCase {
    
    func makeImageResult() -> ImagesResult {
        let picture0 = MyPicture(croppedPictrure: "url0", id: "0")
        let picture1 = MyPicture(croppedPictrure: "url1", id: "1")
        let imageResult = ImagesResult(hasMore: true, page: 1, pageCount: 1, pictures: [picture0, picture1])
        return imageResult
    }
    
    func makeController() -> (ViewController, SpyImageLoader, StubImageDataLoader) {
        let imageDataLoader = StubImageDataLoader()
        let imagesLoader = SpyImageLoader()
        return (ImageUIComposer.makeViewController(imagesLoader: imagesLoader, imageDataLoader: imageDataLoader), imagesLoader, imageDataLoader)
    }
    
    func test_LoadImageFeed_RequestDataFromRemote() {
        let (viewController, imagesLoader, _) = makeController()
        viewController.collectionViewController.loadViewIfNeeded()
        imagesLoader.finish(with: .success(makeImageResult()), at: 0)
        XCTAssertEqual(1, imagesLoader.count)
    }
    
    func test_LoadImageFeed_RenderDataOnUI() {
        let (viewController, imagesLoader, _) = makeController()
        
        
        viewController.collectionViewController.loadViewIfNeeded()
        imagesLoader.finish(with: .success(makeImageResult()), at: 0)
        XCTAssertEqual(2, viewController.collectionViewController.numberOfRenderedFeedImageViews())
    }
    
    func test_LoadImageFeed_RenderLabelOnUI() {
        let (viewController, imagesLoader, _) = makeController()
        
        viewController.collectionViewController.loadViewIfNeeded()
        imagesLoader.finish(with: .success(makeImageResult()), at: 0)
        let cell0 = viewController.collectionViewController.simulateFeedImageViewVisible(at: 0)
        let cell1 = viewController.collectionViewController.simulateFeedImageViewVisible(at: 1)
        
        XCTAssertEqual(cell0?.text, "0")
        XCTAssertEqual(cell1?.text, "1")
    }
    
    func test_LoadImageFeed_isActivityAnimator_Animating() {
        let (viewController, imagesLoader, _) = makeController()
        
        viewController.collectionViewController.loadViewIfNeeded()
        imagesLoader.finish(with: .success(makeImageResult()), at: 0)
        let cell0 = viewController.collectionViewController.simulateFeedImageViewVisible(at: 0)
        let cell1 = viewController.collectionViewController.simulateFeedImageViewVisible(at: 1)
        XCTAssertTrue(cell0?.isShowingImageLoadingIndicator == true)
        XCTAssertTrue(cell1?.isShowingImageLoadingIndicator == true)
    }
    
    func test_LoadImageFeed_isRefreshControl_Animating() {
        let (viewController, imagesLoader, _) = makeController()
        
        viewController.collectionViewController.loadViewIfNeeded()
        
        XCTAssertTrue(viewController.collectionViewController.collectionView.refreshControl?.isRefreshing == true)
        
    }
    
    func test_ImageView_isRendered() {
        let (viewController, imagesLoader, dataLoader) = makeController()
        
        viewController.collectionViewController.loadViewIfNeeded()
        imagesLoader.finish(with: .success(makeImageResult()), at: 0)
        let data0 = UIImage.make(withColor: .blue).pngData()
        let data1 = UIImage.make(withColor: .blue).pngData()
        
        let cell0 = viewController.collectionViewController.simulateFeedImageViewVisible(at: 0)
        let cell1 = viewController.collectionViewController.simulateFeedImageViewVisible(at: 1)
        dataLoader.finishDownload(at: 0, with: .success(data0!))
        dataLoader.finishDownload(at: 1, with: .success(data1!))
        XCTAssertEqual(2, dataLoader.count)
        XCTAssertEqual(cell0?.image, data0)
        XCTAssertEqual(cell1?.image, data1)
        
    }
    
    func test_ImageView_Prefetching() {
        let (viewController, imagesLoader, dataLoader) = makeController()
        
        viewController.collectionViewController.loadViewIfNeeded()
        
    
        imagesLoader.finish(with: .success(makeImageResult()), at: 0)
        viewController.collectionViewController.simulateFeedImageViewNearVisible(at: 0)
        viewController.collectionViewController.simulateFeedImageViewNearVisible(at: 1)
        
        let urls: [URL] = makeImageResult().pictures.map { URL(string: $0.croppedPictrure)! }
        XCTAssertEqual(dataLoader.downloadedUrls, urls)
    }
}

extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
