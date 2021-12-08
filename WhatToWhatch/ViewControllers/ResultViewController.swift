//
//  ResultViewController.swift
//  MovieApp
//
//  Created by Andrey Markov on 2021-06-08.
//

import UIKit
import Koloda

class ResultViewController: UIViewController {
    @IBOutlet open weak var kolodaView: KolodaView!
    
    var images = [Int:UIImage]()
    {didSet {
        DispatchQueue.main.async {
            self.kolodaView.reloadData()
        }
    }}
    
    var urls = [URL]()
   
    
    var models = [TinderCardModel]()
    {didSet {
        DispatchQueue.main.async {
            self.urls = self.models.map { $0.imageUrl}
            for i in 0 ..< self.urls.count{
                self.downloadImage(from: self.urls[i],with: i)
            }
        }
    }}

    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            kolodaView.resetCurrentCardIndex()
            models.removeAll()
            images.removeAll()
            urls.removeAll()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension ResultViewController{
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL, with key:Int) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                let image = UIImage(data: data)
                if image != nil{
                    self.images.updateValue(image!, forKey: key)
                }
            }
        }
    }
}
extension ResultViewController: KolodaViewDelegate{
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
            koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if (direction == .right){
            StorageManager.shared.save(id: models[index].id,image: images[index]!, rating: models[index].rating, title: models[index].title, releaseDate: models[index].releaseDate, imageUrl: models[index].imageUrl,like: false)
        }
    }
}
extension ResultViewController:KolodaViewDataSource{
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return images.count
      }
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        let overlayView = Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
        overlayView?.frame = view!.bounds
        koloda.backgroundColor = .white
        return overlayView
        }
      func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = Bundle.main.loadNibNamed("CustomView", owner: self, options: nil)?[0] as? CustomView
        view?.customImageView.image = images[index]
        view?.customTitleLabel.text = models[index].title
        view?.customRatingLabel.text = "Rating:" + String(models[index].rating)
        view?.customYearLabel.text = " Year:" + models[index].releaseDate
        view?.customImageView.contentMode = .scaleAspectFill
        view?.customImageView.frame.size.width = view!.bounds.size.width
        view?.sendSubviewToBack((view?.subviews.last)!)
        navigationController?.navigationBar.backgroundColor = ApplicationScheme.shared.colorScheme.secondaryColor
        view?.backgroundColor = ApplicationScheme.shared.colorScheme.backgroundColor
        return view!
      }
}
