//
//  DataViewController.swift
//  MovieApp
//
//  Created by Andrey Markov on 2021-06-29.
//

import UIKit

class DataViewController: UITableViewController {
    var models = StorageManager.shared.fetchData()
    {didSet {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        models = StorageManager.shared.fetchData()
        tableView.reloadData()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MovieTableViewCell

        let model = models[indexPath.row]
        cell.delegate = self
        cell.likeOutlet.tag = indexPath.row
        if(model.like == true){
            cell.likeOutlet.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
        }else{
            cell.likeOutlet.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)

        }
        cell.imageView?.image = UIImage(data: model.image!)
        cell.titleLabel.text = model.title ?? "" + "/" + (model.releaseDate?.prefix(4))!
        cell.ratingLabel.text = String(model.rating)

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        
        if editingStyle == .delete {
            models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.delete(model)
        }
    }
}
extension DataViewController: MovieTableViewCellDelegate{
    func likeButton(tag: Int) {
        if (models[tag].like == true) {
            StorageManager.shared.saveLike(models[tag], like: false)
            tableView.reloadData()
           }
           else if(models[tag].like == false){
            StorageManager.shared.saveLike(models[tag], like: true)
            tableView.reloadData()
           }
    }
}

