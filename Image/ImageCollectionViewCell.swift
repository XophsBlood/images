//
//  ImageCollectionViewCell.swift
//  Image
//
//  Created by Камиль Бакаев on 22.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
   
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
    
    override func layoutSubviews() {
        backgroundColor = .yellow
        configure()
    }
    
    
    func configure() {
        addSubview(newsTextLabel)
        addSubview(newsImageView)
        let image = UIImage(named: "interface")
        let imageWidth = image?.size.width
        let imageHeight = image?.size.height
        let multipl = imageWidth! / imageHeight!
        newsImageView.image = image
        newsTextLabel.text = "Image"
        newsImageView.sizeToFit()

        print(newsImageView.sizeThatFits(CGSize(width: contentView.bounds.width - 40, height: 10000)))
        newsImageView.frame = CGRect(x: 20, y: 20, width: contentView.bounds.width - 40, height: (contentView.bounds.width - 40)/multipl)
        
        newsImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        newsImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        newsImageView.bottomAnchor.constraint(equalTo: newsTextLabel.bottomAnchor, constant: -20).isActive = true
        newsImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        
        newsTextLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        newsTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        
       
    }
}
