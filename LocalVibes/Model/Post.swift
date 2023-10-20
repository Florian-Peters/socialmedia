//
//  Post.swift
//  LocalVibes
//
//  Created by Florian Peters on 19.10.23.
//

import SwiftUI
import FirebaseFirestoreSwift

// MARK: Post Model
struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    var imageUrl: URL?
    var imageReferenceID: String = ""
    var publishedDate: Date = Date()
    var likesIDs: [String] = []
    var dislikedIDs: [String] = []

    var userName: String
    var userUID: String
    var userProfileURL: URL

    enum CodingKeys: CodingKey {
        case id
        case imageUrl
        case imageReferenceID
        case publishedDate
        case likesIDs
        case dislikedIDs
        case userName
        case userUID
        case userProfileURL
    }
}
