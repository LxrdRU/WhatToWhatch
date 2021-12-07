//
//  MainViewController.swift
//  WhatToWhatch
//
//  Created by Andrey Markov on 2021-07-01.
//

import UIKit
import BEMCheckBox
import LGButton
import MaterialComponents
class MainViewController: UIViewController, BEMCheckBoxDelegate{
    
    var tags = [Int]()
    var models = [TinderCardModel]()
    
    
    @IBOutlet weak var searchButton: MDCButton!
    
    @IBOutlet var checkBoxes: [BEMCheckBox]!
    
    @IBOutlet var textLabels: [UILabel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareVC()
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
        NetworkManager.shared.searchMovies(array: tags) { (movies, err) in
            for i in 0 ..< movies.count{
                self.models.append(TinderCardModel(title: movies[i].title, imageUrl: NetworkManager.shared.getURL(posterPath: movies[i].posterPath), rating: movies[i].voteAverage, releaseDate: movies[i].releaseDate, id: movies[i].id))
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
extension MainViewController{
    private func prepareVC(){
        let colorScheme = ApplicationScheme.shared.colorScheme
        let typographyScheme = ApplicationScheme.shared.typographyScheme
        self.view.tintColor = colorScheme.onSurfaceColor
        navigationController?.navigationBar.barTintColor = ApplicationScheme.shared.colorScheme.secondaryColor
        view.backgroundColor = colorScheme.secondaryColor
        searchButton.setTitle("Search", for: .normal)
        MDCButtonTypographyThemer.applyTypographyScheme(typographyScheme, to: searchButton)
    
        MDCButtonColorThemer.applySemanticColorScheme(colorScheme,to: searchButton )
        for checkbox in checkBoxes{
            checkbox.delegate = self
        }
        
        for textLabel in textLabels{
            textLabel.font = typographyScheme.subtitle1
        }

    }
}

