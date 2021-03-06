//
//  CoreDataManager.swift
//  LastFM-App
//
//  Created by Erich Flock on 01.03.21.
//

import CoreData

protocol CoreDataManagerSaveProtocol {
    func saveAlbum(newAlbum: Album)
}

protocol CoreDataManagerDeleteProtocol {
    func deleteAlbum(album: Album)
}

protocol CoreDataManagerFetchAlbumsProtocol {
    func fetchAlbums() -> [Album]
}

protocol CoreDataManagerFetchAlbumProtocol {
    func fetch(album: Album) -> Album?
}

protocol CoreDataManagerDeleteAllProtocol {
    func deleteAll()
}

typealias CoreDataManagerProtocol = CoreDataManagerSaveProtocol & CoreDataManagerDeleteProtocol & CoreDataManagerFetchAlbumsProtocol & CoreDataManagerFetchAlbumProtocol & CoreDataManagerDeleteAllProtocol

class CoreDataManager: CoreDataManagerProtocol {
    
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
    
    func saveAlbum(newAlbum: Album) {
        guard isAlbumAlreadySaved(album: newAlbum) == false else { return }
        
        let albumEntity = NSEntityDescription.entity(forEntityName: "AlbumCoreData", in: managedContext)!
        let trackEntity = NSEntityDescription.entity(forEntityName: "TrackCoreData", in: managedContext)!
      
        let album = NSManagedObject(entity: albumEntity, insertInto: managedContext) as! AlbumCoreData
        album.setValue(newAlbum.name, forKeyPath: "name")
        album.setValue(newAlbum.artistName, forKeyPath: "artistName")
        album.setValue(newAlbum.imageURLString, forKeyPath: "imageURLString")
        if let tracks = newAlbum.tracks {
            for track in tracks {
                let trackCoreData = NSManagedObject(entity: trackEntity, insertInto: managedContext) as! TrackCoreData
                trackCoreData.setValue(track.name, forKeyPath: "name")
                album.addToTracks(trackCoreData)
            }
        }
      
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAlbum(album: Album) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AlbumCoreData")
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND artistName == %@", album.name, album.artistName)

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
                    if let name = fetchedAlbum.name, let imageURLString = fetchedAlbum.imageURLString, let artistName = fetchedAlbum.artistName, let tracks = fetchedAlbum.tracks?.allObjects as? [TrackCoreData] {
                        let album: Album = .init(name: name, imageURLString: imageURLString, artistName: artistName, tracks: mapTracksCoreDataToTracks(tracks), isSaved: true)
                        albums.append(album)
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return albums
    }
    
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "AlbumCoreData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Could not delete albums. \(error), \(error.userInfo)")
        }
    }
    
    func fetch(album: Album) -> Album? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AlbumCoreData")
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND artistName == %@", album.name, album.artistName)
        do {
            if let fetchedAlbums = try managedContext.fetch(fetchRequest) as? [AlbumCoreData] {
                let fetchedAlbum = fetchedAlbums.first
                if let name = fetchedAlbum?.name, let image = fetchedAlbum?.imageURLString, let artistiName = fetchedAlbum?.artistName, let tracks = fetchedAlbum?.tracks?.allObjects as? [TrackCoreData] {
                    return .init(name: name, imageURLString: image, artistName: artistiName, tracks: mapTracksCoreDataToTracks(tracks), isSaved: true)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
}

//MARK: Helpers
extension CoreDataManager {
    
    private func isAlbumAlreadySaved(album: Album) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AlbumCoreData")
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND artistName == %@", album.name, album.artistName)
        do {
            if let fetchedAlbums = try managedContext.fetch(fetchRequest) as? [AlbumCoreData], !fetchedAlbums.isEmpty {
                return true
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return false
    }
    
    private func mapTracksCoreDataToTracks(_ tracksCoreData: [TrackCoreData]) -> [Album.Track] {
        var tracks: [Album.Track] = []
        for trackCoreData in tracksCoreData {
            if let name = trackCoreData.name {
                tracks.append(.init(name: name))
            }
        }
        return tracks
    }

}
