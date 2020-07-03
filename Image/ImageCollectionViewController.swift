//
//  ImageCollectionViewController.swift
//  Image
//
//  Created by Камиль Бакаев on 22.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import UIKit
import CoreLogic

private let reuseIdentifier = "Cell"

protocol ImageListView {
    func display(images: [MyPicture])
}

class ImageCollectionViewController: UICollectionViewController {
    
    var imageViewControllerDelegate: ImageViewControllerDelegate?
    
    var images: [MyPicture] = []
    var imagesData: [Int: Data] = [:]
    var currentPages: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPages = 0
        imagesData = [:]

        imageViewControllerDelegate?.fetchImages()

        self.collectionView!.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.contentInsetAdjustmentBehavior = .never
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        cell.newsImageView.activityIndicator.startAnimating()
        cell.newsImageView.downloadImageData(url: images[indexPath.row].croppedPictrure)
        cell.newsTextLabel.text = images[indexPath.row].id
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (images.count - 1) {
            imageViewControllerDelegate?.nextFetch()
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

extension ImageCollectionViewController: ImageListView {
    func display(images: [MyPicture]) {
        self.images = images
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension UIImageView {
    fileprivate var activityIndicator: UIActivityIndicatorView {
      get {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = CGPoint(x:self.frame.width/2,
                                       y: self.frame.height/2)
        activityIndicator.stopAnimating()
        self.addSubview(activityIndicator)
        return activityIndicator
      }
    }
    
    func downloadImageData(url: String) {
        let session = URLSession(configuration: .default)
        let networkManager = NetworkManager(session: session)
        let imageDataLoader = HTTPImageDataLoader(httpCLient: networkManager)
        let url = URL(string: "\(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")!
        imageDataLoader.getImageData(with: url) { result in
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.image = UIImage(data: data)
                }
            case let .failure(error):
                print(error)
            }
            
        }
    }
}
