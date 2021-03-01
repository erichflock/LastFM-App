//
//  CoreDataManager.swift
//  LastFM-App
//
//  Created by Erich Flock on 01.03.21.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Albums")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveAlbum(newAlbum: Album) {
      
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "AlbumCoreData", in: managedContext)!
      
        let album = NSManagedObject(entity: entity, insertInto: managedContext)
        album.setValue(newAlbum.name, forKeyPath: "name")
        album.setValue(newAlbum.artistName, forKeyPath: "artistName")
        album.setValue(newAlbum.imageURLString, forKeyPath: "imageURLString")
      
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAlbum(album: Album) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AlbumCoreData")
        fetchRequest.predicate = NSPredicate(format: "name == %@", album.name as CVarArg)

        do {
            if let fetchedAlbums = try managedContext.fetch(fetchRequest) as? [AlbumCoreData] {
                for fetchedAlbum in fetchedAlbums {
                    managedContext.delete(fetchedAlbum)
                }
            }
            try? managedContext.save()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchAlbums() -> [Album] {
        
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AlbumCoreData")

        var albums: [Album] = []

        do {
            if let fetchedAlbums = try managedContext.fetch(fetchRequest) as? [AlbumCoreData] {
                
                for fetchedAlbum in fetchedAlbums {
                    if let name = fetchedAlbum.name, let imageURLString = fetchedAlbum.imageURLString, let artistName = fetchedAlbum.artistName {
                        let album: Album = .init(name: name, imageURLString: imageURLString, artistName: artistName, tracks: nil)
                        albums.append(album)
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return albums
    }
}
