//
//  DetailMovieViewController.swift
//  WhatToWhatch
//
//  Created by Andrey Markov on 2021-07-15.
//

import UIKit
import GravitySliderFlowLayout
import MaterialComponents
class DetailMovieViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

   
    @IBOutlet weak var addButton: MDCButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var colletionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    
    var models = [TinderCardModel]()
    
    
    var mainImage:UIImage!
    {didSet{
        imageView.image = mainImage
    }}
    
    var model:TinderCard!
    {didSet {
        downloadImage(from: model.imageUrl!) //downloads main image
        NetworkManager.shared.searchSimilarMoviesById(id: String(model.id)) { movies, err in
            for movie in movies{
                self.models.append(TinderCardModel(title: movie.title, imageUrl: NetworkManager.shared.getURL(posterPath: movie.posterPath), rating: movie.voteAverage, releaseDate: movie.releaseDate, id: movie.id))
                self.relatedMoviesUrls.append(NetworkManager.shared.getURL(posterPath: movie.posterPath))
            }
        }
    }}
    
    var relatedMoviesImages = [UIImage]()
    {didSet {
        DispatchQueue.main.async {
            self.colletionView.reloadData()
        }
    }}
    
    var relatedMoviesUrls = [URL]()
    {didSet {
        if (relatedMoviesUrls.count == 5){
            downloadPhoto()
        }
        relatedMoviesUrls = relatedMoviesUrls.unique()
    }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSliderAndStyle()
        
    }
    //clear data
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            relatedMoviesImages.removeAll()
            relatedMoviesUrls.removeAll()
        }
    }
    
    //adding selected related movie to data tableview
    @IBAction func addButtonPressed(_ sender: Any) {
        if let collectionView = self.colletionView,
           let indexPath = collectionView.indexPathsForSelectedItems?.first{
            StorageManager.shared.save(id: models[indexPath.row].id, image: relatedMoviesImages[indexPath.row], rating: models[indexPath.row].rating, title: models[indexPath.row].title, releaseDate: models[indexPath.row].releaseDate, imageUrl: models[indexPath.row].imageUrl, like: false)
            let alert = UIAlertController(title: "Done", message: "Movie has been added.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        relatedMoviesImages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.reuseIdentifier, for: indexPath) as! MoviesCollectionViewCell
        self.configureCell(cell, for: indexPath)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .bottom)
    }

   
}
extension DetailMovieViewController{
    func configureCell(_ cell: MoviesCollectionViewCell, for indexPath: IndexPath) {
         cell.clipsToBounds = false
        cell.layer.shadowColor = Constants.cellsShadowColor
         cell.layer.shadowOpacity = 0.2
         cell.layer.shadowRadius = 20
         cell.layer.shadowOffset = CGSize(width: 0.0, height: 30)
        cell.image.image = relatedMoviesImages[indexPath.row]
     }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    //downloads main image
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                let image = UIImage(data: data)
                if image != nil{
                    self.mainImage = image
                }
            }
        }
    }
    
    //downloads slider images
    func downloadPhoto(){
        DispatchQueue.global().async {
            self.relatedMoviesImages.removeAll() // this is the image array

            for i in 0..<self.relatedMoviesUrls.count {
                let url = self.relatedMoviesUrls[i]

                let group = DispatchGroup()

                print(url)
                print("-------GROUP ENTER-------")

                group.enter()
                URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                    print(response?.suggestedFilename ?? url.lastPathComponent)

                    if let imgData = data, let image = UIImage(data: imgData) {
                        DispatchQueue.main.async() {
                            self.relatedMoviesImages.append(image)
                        }
                    } else if let error = error {
                        print(error)
                    }

                    group.leave()
                }).resume()

                group.wait()
            }
        }
    }
    
    func prepareSliderAndStyle() {
        let gravitySliderLayout = GravitySliderFlowLayout(with: CGSize(width: colletionView.frame.size.height * Constants.collectionViewCellWidthCoefficient, height: colletionView.frame.size.height * Constants.collectionViewCellHeightCoefficient))
        colletionView.collectionViewLayout = gravitySliderLayout
        colletionView.dataSource = self
        colletionView.delegate = self
        ratingLabel.text = String(model.rating)
        titleLabel.text = model.title
        title = model.title
        let colorScheme = ApplicationScheme.shared.colorScheme
        let typographyScheme = ApplicationScheme.shared.typographyScheme
        titleLabel.font = typographyScheme.headline6
        ratingLabel.font = typographyScheme.headline6
        self.view.tintColor = colorScheme.onSurfaceColor
        navigationController?.navigationBar.barTintColor = ApplicationScheme.shared.colorScheme.secondaryColor
        view.backgroundColor = colorScheme.secondaryColor
        colletionView.backgroundColor = colorScheme.secondaryColor
        addButton.setTitle("Add", for: .normal)
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = colorScheme.onPrimaryColor.cgColor
        MDCButtonTypographyThemer.applyTypographyScheme(typographyScheme, to: addButton)
        MDCButtonColorThemer.applySemanticColorScheme(colorScheme,to:  addButton)
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "purebg")?.draw(in: self.view.bounds)

        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }else{
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
         }
    }
}
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
