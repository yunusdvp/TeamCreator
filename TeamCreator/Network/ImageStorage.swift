//
//  ImageStorage.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 1.08.2024.
//

import Foundation
import UIKit
import FirebaseStorage

protocol ImageStorageProtocol {
//    func uploadProfileImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void)
    func uploadProfileImage(imageData: Data, compressionQuality: CGFloat, completion: @escaping (Result<String, Error>) -> Void)

    func downloadProfileImage(url: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

class ImageStorage: ImageStorageProtocol {
//    func uploadProfileImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
//        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//            completion(.failure(NSError(domain: "ImageConversionError", code: 0, userInfo: nil)))
//            return
//        }
//
//        let storageRef = Storage.storage().reference().child("profile_images").child(UUID().uuidString)
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//        
//        storageRef.putData(imageData, metadata: metadata) { (  metadata, error ) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            storageRef.downloadURL { (url, error) in
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//                
//                guard let downloadURL = url?.absoluteString else {
//                    completion(.failure(NSError(domain: "URLFetchError", code: 0, userInfo: nil)))
//                    return
//                }
//                
//                completion(.success(downloadURL))
//            }
//        }
//    }
    func uploadProfileImage(imageData: Data, compressionQuality: CGFloat = 0.25, completion: @escaping (Result<String, Error>) -> Void) {
        // Convert the image data to UIImage for compression
        if let image = UIImage(data: imageData) {
            // Compress the image to reduce its size
            if let compressedData = image.jpegData(compressionQuality: compressionQuality) {
                let storageRef = Storage.storage().reference().child("profile_images").child(UUID().uuidString)
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                storageRef.putData(compressedData, metadata: metadata) { (_, error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        
                        guard let downloadURL = url?.absoluteString else {
                            completion(.failure(NSError(domain: "URLFetchError", code: 0, userInfo: nil)))
                            return
                        }
                        
                        completion(.success(downloadURL))
                    }
                }
            } else {
                completion(.failure(NSError(domain: "ImageCompressionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image compression failed"])))
            }
        } else {
            completion(.failure(NSError(domain: "ImageConversionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert data to UIImage"])))
        }
    }
    func downloadProfileImage(url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let storageRef = Storage.storage().reference(forURL: url)
        storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(NSError(domain: "ImageDownloadError", code: 0, userInfo: nil)))
            }
        }
    }
}

