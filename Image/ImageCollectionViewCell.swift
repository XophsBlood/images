//
//  ImageCollectionViewCell.swift
//  Image
//
//  Created by Камиль Бакаев on 22.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import UIKit


class ImageCollectionViewCell: UICollectionViewCell {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
   
    let newsTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.autoresizesSubviews = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        addSubview(newsTextLabel)
        addSubview(newsImageView)
        newsTextLabel.text = "Image"
        
        newsImageView.sizeToFit()
        
        newsTextLabel.leftAnchor.constraint(equalTo: newsImageView.leftAnchor, constant: 7).isActive = true
        newsTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        newsImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        newsImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        newsImageView.bottomAnchor.constraint(equalTo: newsTextLabel.bottomAnchor, constant: -20).isActive = true
        newsImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.image = nil
        newsImageView.stopAnimating()
    }
}
