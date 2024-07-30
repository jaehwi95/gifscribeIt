//
//  PostClient.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/25.
//

import Foundation
import FirebaseDatabase
import ComposableArchitecture

struct PostClient {
    var getAllPosts: () async -> Result<[Post], PostError>
    var addPost: (_ post: Post) -> Result<Void, PostError>
    var deletePost: (_ id: String) -> Void
    var addPointFromPost: (_ id: String) async -> Result<Void, PostError>
    var subtractPointFromPost: (_ id: String) async -> Result<Void, PostError>
    var reportPost: (_ id: String, _ reportCategory: String, _ email: String) async -> Result<Void, PostError>
    /// TODO: edit post
//    var editPost: (_ post: Post) -> Result<Void, PostError>
}

extension DependencyValues {
    var postClient: PostClient {
        get { self[PostClient.self] }
        set { self[PostClient.self] = newValue }
    }
}

extension PostClient: DependencyKey {
    static var liveValue: PostClient = {
        let ref: DatabaseReference = Database.database().reference()
        let dbPath = "posts"
        
        return PostClient(
            getAllPosts: {
                do {
                    let snapshot = try await ref.child(dbPath).getData()
                    guard let resultDictionary = snapshot.value as? [String: Any] else {
                        return .failure(.parseError)
                    }
                    var resultList: [Post] = []
                    for (key, value) in resultDictionary {
                        guard let post = try? Post.decode(value) else {
                            return .failure(.decodeError)
                        }
                        resultList.append(post)
                    }
                    return .success(resultList)
                } catch {
                    return .failure(.otherError(error.localizedDescription))
                }
            },
            addPost: { post in
                do {
                    guard let autoId = ref.child(dbPath).childByAutoId().key else {
                        return .failure(.autoIdFailure)
                    }
                    let postWithId = post.setId(id: autoId)
                    guard let postId = postWithId.id else {
                        return .failure(.emptyPostId)
                    }
                    try ref.child("\(dbPath)/\(postId)").setValue(from: postWithId)
                    return .success(())
                } catch {
                    return .failure(.otherError(error.localizedDescription))
                }
            },
            deletePost: { id in
                ref.child("\(dbPath)/\(id)").removeValue()
            },
            addPointFromPost: { id in
                do {
                    let snapshot = try await ref.child("\(dbPath)/\(id)").getData()
                    guard let resultDictionary = snapshot.value as? [String: Any] else {
                        return .failure(.parseError)
                    }
                    guard let currentPoint: Int = resultDictionary["point"] as? Int else {
                        return .failure(.pointIsNull)
                    }
                    try await ref.child("\(dbPath)/\(id)")
                        .updateChildValues([
                            "point": (currentPoint + 1)
                        ])
                    return .success(())
                } catch {
                    return .failure(.otherError(error.localizedDescription))
                }
            },
            subtractPointFromPost: { id in
                do {
                    let snapshot = try await ref.child("\(dbPath)/\(id)").getData()
                    guard let resultDictionary = snapshot.value as? [String: Any] else {
                        return .failure(.parseError)
                    }
                    guard let currentPoint: Int = resultDictionary["point"] as? Int else {
                        return .failure(.pointIsNull)
                    }
                    try await ref.child("\(dbPath)/\(id)")
                        .updateChildValues([
                            "point": (currentPoint - 1)
                        ])
                    return .success(())
                } catch {
                    return .failure(.otherError(error.localizedDescription))
                }
            },
            reportPost: { id, reportCategory, email in
                do {
                    let snapshot = try await ref.child("\(dbPath)/\(id)").getData()
                    guard let resultDictionary = snapshot.value as? [String: Any] else {
                        return .failure(.parseError)
                    }
                    
                    guard let newReport = try Report(
                        reportCategory: reportCategory,
                        reportUser: email
                    ).encode() as? [AnyHashable: Any] else {
                        return .failure(.parseError)
                    }
                    
                    try await ref.child("\(dbPath)/\(id)")
                        .updateChildValues([
                            "report": newReport
                        ])
                    return .success(())
                } catch {
                    return .failure(.otherError(error.localizedDescription))
                }
            }
        )
    }()
}
