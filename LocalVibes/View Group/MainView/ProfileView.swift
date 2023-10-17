//
//  ProfileView.swift
//  LocalVibes
//
//  Created by Florian Peters on 17.10.23.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    // MARK: My Profile Data
    @State private var myProfile: User?
    @AppStorage("log_status") var logStatus: Bool = false

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                if let user = myProfile {
                    Text("Name: ")
                    Text("Email: ")
                    // Add more profile information here
                } else {
                    Text("Loading profile...")
                }
            }
            .refreshable {
                // TODO: Implement a refresh action to update the user's profile data
            }
            .navigationTitle("My Profile")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button("Logout") {
                            logOutUser()
                        }
                        Button("Delete Account", role: .destructive) {
                            // Add code to delete the user's account
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .tint(.black)
                            .scaleEffect(0.8)
                    }
                }
            }
        }
    }

    func logOutUser() {
        try? Auth.auth().signOut()
        logStatus = false
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
