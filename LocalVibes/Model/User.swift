//
//  User.swift
//  LocalVibes
//
//  Created by Florian Peters on 12.10.23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var userBio: String // Changed the property name to follow Swift conventions
    var userBioLink: String
    var userUID: String
    var userEmail: String
    var userProfileURL: URL

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case userBio
        case userBioLink
        case userUID
        case userEmail
        case userProfileURL

    }
}
