//
//  StorageManager.swift
//  WhatToWhatch
//
//  Created by Andrey Markov on 2021-07-01.
//


import CoreData
import UIKit
class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WhatToWhatch")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
    
    // MARK: - Public Methods
    func fetchData() -> [TinderCard] {
        let fetchRequest: NSFetchRequest<TinderCard> = TinderCard.fetchRequest()
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch data", error)
            return []
        }
    }
    
    // Save data
    func save( image: UIImage, rating: Double, title: String, releaseDate: String , imageUrl:URL, like:Bool) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "TinderCard", in: persistentContainer.viewContext) else { return }
        let card = NSManagedObject(entity: entityDescription, insertInto: viewContext) as! TinderCard
        card.image = image.pngData()
        card.rating = rating
        card.title = title
        card.releaseDate = releaseDate
        card.imageUrl = imageUrl
        card.like = like
        saveContext()
    }
    
    func saveLike(_ card: TinderCard, like: Bool) {
        card.like = like
        saveContext()
    }
    
    func delete(_ card: TinderCard) {
        viewContext.delete(card)
        saveContext()
    }

    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
