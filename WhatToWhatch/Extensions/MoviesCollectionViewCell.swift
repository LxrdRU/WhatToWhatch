//
//  MoviesCollectionViewCell.swift
//  WhatToWhatch
//
//  Created by Andrey Markov on 2021-07-15.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    static let reuseIdentifier = "cell"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
