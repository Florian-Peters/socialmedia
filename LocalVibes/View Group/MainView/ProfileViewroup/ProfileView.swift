//
//  ProfileView.swift
//  LocalVibes
//
//  Created by Florian Peters on 17.10.23.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage

struct ProfileView: View {
    // MARK: My Profile Data
    @State private var myProfile: User?
    @AppStorage("log_status") var logStatus: Bool = false
    // MARK: ERROR MESSAGE
    @State var errorMessage: String = ""
    @State var showEror: Bool = false
    @State var isLoading : Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    if let myProfile {
                        ResusableProfileContent(user: myProfile)
                            .refreshable {
                                
                                self.myProfile = nil
                                await fetchUserData()
                            }
                    } else {
                        
                        ProgressView()
                    }
                }
            }
            .navigationTitle("My Profile")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button("Logout") {
                            logOutUser()
                        }
                        Button("Delete Account", role: .destructive) {
                            deleteAccount()
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
        .overlay {
            LoadingView(show: $isLoading)
        }
        .alert(errorMessage, isPresented: $showEror) {}
        .task {
            if myProfile != nil {
                return
            }
            await fetchUserData()
        }
    }
    
    func fetchUserData() async {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }
        guard let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self) else {
            return
        }
        await MainActor.run {
            myProfile = user
        }
    }
    
    func logOutUser() {
        try? Auth.auth().signOut()
        logStatus = false
    }
    
    func deleteAccount() {
        isLoading = true
        Task {
            do {
                guard let userUID = Auth.auth().currentUser?.uid else {
                    return
                }
                let reference = Storage.storage().reference().child("/Profiel_Images").child(userUID)
                try await reference.delete()
                try await Firestore.firestore().collection("Users").document(userUID).delete()
                try await Auth.auth().currentUser?.delete()
                logStatus = false
            } catch {
                await setError(error)
            }
        }
    }
    
    // Setting Error
    @Sendable func setError(_ error: Error) async {
        await MainActor.run {
            isLoading = false
            errorMessage = error.localizedDescription
            showEror.toggle()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
