//
//  MovieTableViewCell.swift
//  WhatToWhatch
//
//  Created by Andrey Markov on 2021-07-06.
//

import UIKit
protocol MovieTableViewCellDelegate:AnyObject{
    func likeButton(tag: Int)
    
}
class MovieTableViewCell: UITableViewCell {

    weak var delegate: MovieTableViewCellDelegate?
   

  
    @IBOutlet weak var likeOutlet: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var customImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButton(_ sender: AnyObject) {
        delegate?.likeButton(tag: sender.tag)
        if(StorageManager.shared.fetchData()[sender.tag].like == true){
            likeOutlet.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
        }else if(StorageManager.shared.fetchData()[sender.tag].like == false){
            likeOutlet.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
        }
    }
}
