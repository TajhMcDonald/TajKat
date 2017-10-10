//
//  DatabaseController.swift
//  TajKat
//
//  Created by Admin on 7/1/17.
//  Copyright © 2017 Adames-McDonald. All rights reserved.
//

import Firebase
import Kingfisher

class DatabaseController {
    lazy var userInformationRef: DatabaseReference = Database.database().reference().child("Users")

    // MARK: - Image Management
    /**
     Downloads an image (from a location in the database) into a specified UIImageView.
     - parameters:
     - destination: The UIImageView that, if successful, will be given the downloaded image
     - location: A path to the image being search for, relative to the root of the storage database
     - completion: Function called when finished, passing back an optional Error object if unsuccessful
     - error: An Error object created and returned if unsuccesful for any reason
     */
    public func downloadImage(into destination: UIImageView, from location: String, completion: @escaping (Error?)->()){
        let store = Storage.storage().reference(withPath: location)
        
        // Check for image saved in cache, load image from disk if possible
        // If it is, proceed with extracting it from cache instead
        if (ImageCache.default.imageCachedType(forKey: store.fullPath).cached) {
            
            ImageCache.default.retrieveImage(forKey: store.fullPath, options: nil) { (image, cacheType) in
                if let image = image {
                    destination.image = image
                }
                
                completion(nil)
            }
            
        } else {
            
            // Otherwise, asynchronously download the file data stored at location and store it for later
            store.downloadURL(completion: { (url, error) in
                guard let url = url else { print("Error: Image download url was nil"); return }
                
                print("Image was not found in cache, downloading and caching now...")
                destination.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { _ in
                    ImageCache.default.store(destination.image!, forKey: store.fullPath)
                })
                
                completion(error)
            })
        }
    }
    
    
    /**
     Uploads an image (in the form of a Data object) to a specified location in the database.
     - parameters:
     - data: The Data object holding the image information to store in the database
     - location: A path for the image data to be saved to, relative to the root of the storage database
     - completion: Function called when finished, passing back an optional Error object when unsuccessful
     - error: An Error object created and returned if unsuccesful for any reason
     */
    public func uploadImage(data: Data, to location: String, completion: @escaping (Error?)->()) {
        var localError: Error?
        let store = Storage.storage().reference(withPath: location)
        
        // Use put() to upload photo using a Data object
        store.putData(data, metadata: nil) { (metadata, error) in
            
            if let error = error { localError = error }
            completion(localError)
        }
    }
    
    
    /**
     Redownloads an image (from a location in the database) into a specified UIImageView. This will clear
     the original image from the cache and reload the image view directly.
     - parameters:
     - destination: The UIImageView that, if successful, will be given the downloaded image
     - location: A path to the image being reloaded, relative to the root of the storage database
     - completion: Function called when finished, passing back an optional Error object if unsuccessful
     - error: An Error object created and returned if unsuccesful for any reason
     */
    public func reloadImage(into destination: UIImageView, from location: String, completion: @escaping (Error?)->()) {
        
        // Convert location to Firebase storage path, remove from cache
        //let store = Storage.storage().reference(withPath: location)
        ImageCache.default.removeImage(forKey: location)
        
        // Redownload the image into cache and the provided image view using another method
        downloadImage(into: destination, from: location, completion: { error in
            completion(error)
        })
    }
    
    /**
     Writes the database storage path of an uploaded display picture to the current user's information record
     - parameters:
     - path: The path where the display picture has been successfully uploaded to
     */
    public func setDisplayPicture(path: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        print("Setting displayPict: \(path)")
        UserState.currentUser.displayPicture = path
        userInformationRef.child("\(uid)/displayPictures").setValue(path)
    }
    
    
    
    /** Clear all images currently cached by the database on disk or memory. */
    public func clearCachedImages() {
        
        // Clear memory cache right away.
        ImageCache.default.clearMemoryCache()
        
        // Clear disk cache. This is an async operation.
        ImageCache.default.clearDiskCache()
        
        // Clean expired or size exceeded disk cache. This is an async operation.
        ImageCache.default.cleanExpiredDiskCache()
        
        print("Image cache cleared from disk and memory")
        ImageCache.default.calculateDiskCacheSize { (size) in print("Used disk size by bytes: \(size)") }
    }
}
