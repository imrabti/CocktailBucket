//
//  Persistence.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 30.05.22.
//

import Foundation
import CoreData

class PersistenceController: ObservableObject {
    static let shared = PersistenceController()
    
    static var attachmentFolder: URL = {
        var url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("CocktailBucket", isDirectory: true)
        url = url.appendingPathComponent("attachments", isDirectory: true)
        
        // Create it if it doesn’t exist.
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("###\(#function): Failed to create thumbnail folder URL: \(error)")
            }
        }
        return url
    }()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "CocktailBucket")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
