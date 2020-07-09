//
//  ImageCollectionViewController.swift
//  Image
//
//  Created by Камиль Бакаев on 22.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import UIKit
import CoreLogic

private let reuseIdentifier = "ImageCollectionViewCell"

protocol ModelsToControllerAdapter {
    func adaptToControllers(images: [ImagePictureModel]) -> ([CellImageViewController])
}

class ImageCollectionViewController: UICollectionViewController {
    
    var imageViewControllerDelegate: ImagesViewModel<UIImage>?
    var footerView:CustomFooterView?
    
    var controllers: [CellImageViewController] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let footerViewReuseIdentifier = "RefreshFooterView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 0, green: 20, blue: 140, alpha: 1))
        collectionView.prefetchDataSource = self
        bind()
        imageViewControllerDelegate?.fetchImages()
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.beginRefreshing()

        self.collectionView.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
        
        self.collectionView!.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.contentInsetAdjustmentBehavior = .never
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = controllers[indexPath.row].createCell(collectionView: collectionView, indexPath: indexPath)
        
        return cell
    }
    
    @objc func nextFetch() {
        imageViewControllerDelegate?.nextFetch()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! CustomFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.prepareInitialAnimation()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.stopAnimate()
        }
    }
    
    //compute the scroll value and play witht the threshold to get desired effect
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 100.0 ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(abs(triggerThreshold),1.0);
        self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            self.footerView?.animateFinal()
        }
    }
    
    //compute the offset and call the load method
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = abs(diffHeight - frameHeight);
        if pullHeight == 0.0 {
            guard let footerView = self.footerView, footerView.isAnimatingFinal else { return }
            
            self.footerView?.startAnimate()
            nextFetch()
        }
    }
    
    func bind() {
        imageViewControllerDelegate?.didDownloaded = { result in
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.refreshControl = nil
            self.controllers = result
        }
    }
}

extension ImageCollectionViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            controllers[item.row].prefetch()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            controllers[item.row].cancel()
        }
    }
}


extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if traitCollection.horizontalSizeClass == .regular {
            return CGSize(width: collectionView.bounds.width/2.05 - collectionView.contentInset.left - collectionView.contentInset.right - 1, height: collectionView.bounds.width/2.05)
        }
        return CGSize(width: collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right - 1, height: collectionView.bounds.width)
    }
}


