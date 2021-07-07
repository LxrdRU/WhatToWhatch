//
//  CustomView.swift
//  MovieApp
//
//  Created by Andrey Markov on 2021-06-26.
//

import UIKit

class CustomView: UIView {
    
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var customRatingLabel: UILabel!
    @IBOutlet weak var customYearLabel: UILabel!
    
    @IBOutlet weak var customTitleLabel: UILabel!
    
    
}
extension UIImageView{
    public func imageFromUrl(url: URL) {
                let request = URLRequest(url: url as URL)
                URLSession.shared.dataTask(with: request) {[unowned self] data, response, error in
                    if let data = data {
                        self.image = UIImage(data: data)
                    }
                }
        }
}
