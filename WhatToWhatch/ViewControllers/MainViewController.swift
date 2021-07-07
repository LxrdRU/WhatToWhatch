//
//  MainViewController.swift
//  WhatToWhatch
//
//  Created by Andrey Markov on 2021-07-01.
//

import UIKit
import BEMCheckBox
import LGButton

class MainViewController: UIViewController, BEMCheckBoxDelegate{
    var backgroundImage: UIImageView!
    
    var tags = [Int]()
    var models = [TinderCardModel]()
    
    @IBOutlet weak var horrorCheckBox: BEMCheckBox!
    @IBOutlet weak var comedyCheckBox: BEMCheckBox!
    @IBOutlet weak var dramaCheckBox: BEMCheckBox!
    @IBOutlet weak var fantasyCheckBox: BEMCheckBox!
    @IBOutlet weak var thrillerCheckBox: BEMCheckBox!
    @IBOutlet weak var adventureCheckBox: BEMCheckBox!
 
    @IBOutlet weak var actionCheckBox: BEMCheckBox!
    
    
    @IBOutlet weak var animationCheckBox: BEMCheckBox!
    @IBOutlet weak var crimeCheckBox: BEMCheckBox!
    @IBOutlet weak var familyCheckBox: BEMCheckBox!
    @IBOutlet weak var historyCheckBox: BEMCheckBox!
    @IBOutlet weak var mysteryCheckBox: BEMCheckBox!
    @IBOutlet weak var romanceCheckBox: BEMCheckBox!
    @IBOutlet weak var sciencefCheckBox: BEMCheckBox!
    @IBOutlet weak var warCheckBox: BEMCheckBox!
    @IBOutlet weak var westernCheckBox: BEMCheckBox!
    @IBOutlet weak var musicCheckBox: BEMCheckBox!
    @IBOutlet weak var tvmovieCheckBox: BEMCheckBox!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        horrorCheckBox.delegate = self
        comedyCheckBox.delegate = self
        dramaCheckBox.delegate = self
        fantasyCheckBox.delegate = self
        thrillerCheckBox.delegate = self
        adventureCheckBox.delegate = self
        actionCheckBox.delegate = self
        animationCheckBox.delegate = self
        crimeCheckBox.delegate = self
        familyCheckBox.delegate = self
        historyCheckBox.delegate = self
        mysteryCheckBox.delegate = self
        romanceCheckBox.delegate = self
        sciencefCheckBox.delegate = self
        warCheckBox.delegate = self
        westernCheckBox.delegate = self
        musicCheckBox.delegate = self
        tvmovieCheckBox.delegate = self
        self.backgroundImage = UIImageView(image: UIImage(named: "bg"))
        self.backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(self.backgroundImage, at: 0)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.backgroundImage.frame = self.view.bounds
    }
    func didTap(_ checkBox: BEMCheckBox) {
        let picked = checkBox.tag
        if tags.contains(picked){
            guard let index = tags.lastIndex(of: picked) else { return }
            tags.remove(at: index)
        }else{
            tags.append(checkBox.tag)
        }
    }
   
    @IBAction func searchButton(_ sender: Any) {
        NetworkManager.shared.searchMovies(array: tags) { array, error in
            for i in 0 ..< array.count{
                self.models.append(TinderCardModel(title: array[i].title, imageUrl: self.getURL(posterPath: array[i].posterPath), rating: array[i].voteAverage, releaseDate: array[i].releaseDate))
            }
            self.performSegue(withIdentifier: "segueShowNavigation", sender: Any?.self)
        
        }
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if models.isEmpty == false{
            if (segue.identifier == "segueShowNavigation"){
                if segue.destination is ResultViewController {
                        let resultViewController = segue.destination as? ResultViewController
                    resultViewController?.models = models
                    models.removeAll()
                    }
            }
        }
    }
    
}
extension MainViewController {
    func getURL(posterPath: String) -> URL{
        let urlFromPath = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")!
        return urlFromPath
    }
}
