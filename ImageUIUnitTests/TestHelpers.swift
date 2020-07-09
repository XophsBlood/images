import UIKit
@testable import Image

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

extension ImageCollectionViewCell {
    var isShowingImageLoadingIndicator: Bool {
        return activityIndicator.isAnimating
    }
    
    var text: String? {
        return self.newsTextLabel.text
    }
    
    var image: Data? {
        return self.newsImageView.image?.pngData()
    }
}


extension ImageCollectionViewController {
    @discardableResult
    func simulateFeedImageViewVisible(at index: Int) -> ImageCollectionViewCell? {
        return feedImageView(at: index) as? ImageCollectionViewCell
    }
    
    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> ImageCollectionViewCell? {
        let view = simulateFeedImageViewVisible(at: row)
        
        let delegate = collectionView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.collectionView?(collectionView, didEndDisplaying: view!, forItemAt: index)
        
        return view
    }
    
    func simulateFeedImageViewNearVisible(at row: Int) {
        let ds = collectionView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.collectionView(collectionView, prefetchItemsAt: [index])
    }
    
    func simulateFeedImageViewNotNearVisible(at row: Int) {
        simulateFeedImageViewNearVisible(at: row)
        
        let ds = collectionView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.collectionView?(collectionView, cancelPrefetchingForItemsAt: [index])
    }
    
    func renderedFeedImageData(at index: Int) -> Data? {
        return simulateFeedImageViewVisible(at: index)?.image
    }

    func numberOfRenderedFeedImageViews() -> Int {
        return collectionView.numberOfItems(inSection: feedImagesSection)
    }
    
    func feedImageView(at row: Int) -> UICollectionViewCell? {
        guard numberOfRenderedFeedImageViews() > row else {
            return nil
        }
        let ds = collectionView.dataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        return ds?.collectionView(collectionView, cellForItemAt: index)
    }
    
    private var feedImagesSection: Int {
        return 0
    }
}
