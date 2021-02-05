//
//  FirebasePostService.swift
//  Instagram
//
//  Created by Admin on 03.02.2021.
//

import FirebaseDatabase

enum FirebasePostService {
    private static let databaseReference = Database.database().reference()
}

// MARK: - Public Methods

extension FirebasePostService {
    static func sharePost(
        identifier: String,
        imageData: Data,
        caption: String?,
        completion: @escaping (Error?) -> Void) {
        FirebaseStorageService.storeUserPostImageData(imageData, identifier: identifier) { result in
            switch result {
            case .success(let imageURL):
                createPostRecord(identifier: identifier, imageURL: imageURL, caption: caption) { error in
                    completion(error)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func fetchPosts(
        identifier: String,
        completion: @escaping (Result<[Post], Error>) -> Void) {
        databaseReference
            .child(FirebaseTables.posts)
            .child(identifier)
            .observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else { return }
            
            var posts = [Post]()
            
            value.forEach { identifier, postValue in
                guard
                    let postDictionary = postValue as? [String: Any],
                    let post = JSONCoding.fromDictionary(postDictionary, type: Post.self)
                else {
                    return
                }
                
                posts.append(post)
            }
                
            posts.sort { $0.timestamp < $1.timestamp }
            
            completion(.success(posts))
        } withCancel: { error in
            completion(.failure(error))
        }

    }
}

// MARK: - Private Methods

private extension FirebasePostService {
    static func createPostRecord(
        identifier: String,
        imageURL: String,
        caption: String?,
        completion: @escaping (Error?) -> Void
    ) {
        let post = Post(imageURL: imageURL, caption: caption, timestamp: Date().timeIntervalSince1970)
        
        if let postDictionary = JSONCoding.toDictionary(post) {
            databaseReference
                .child(FirebaseTables.posts)
                .child(identifier)
                .childByAutoId()
                .setValue(postDictionary) { error, _ in
                completion(error)
            }
        }
    }
}