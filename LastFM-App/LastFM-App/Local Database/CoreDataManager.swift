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
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Albums")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private func saveContext () {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveAlbum(newAlbum: Album) {
        guard isAlbumAlreadySaved(album: newAlbum) == false else { return }
        
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AlbumCoreData")

        var albums: [Album] = []

        do {
            if let fetchedAlbums = try managedContext.fetch(fetchRequest) as? [AlbumCoreData] {
                
                for fetchedAlbum in fetchedAlbums {
                    if let name = fetchedAlbum.name, let imageURLString = fetchedAlbum.imageURLString, let artistName = fetchedAlbum.artistName {
                        let album: Album = .init(name: name, imageURLString: imageURLString, artistName: artistName, tracks: nil, isSaved: true)
                        albums.append(album)
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return albums
    }
    
    private func isAlbumAlreadySaved(album: Album) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AlbumCoreData")
        fetchRequest.predicate = NSPredicate(format: "name == %@", album.name as CVarArg)
        do {
            if let fetchedAlbums = try managedContext.fetch(fetchRequest) as? [AlbumCoreData], !fetchedAlbums.isEmpty {
                return true
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return false
    }
}
