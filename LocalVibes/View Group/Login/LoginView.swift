//  LoginView.swift
//  LocalVibes
//
//  Created by Florian Peters on 11.10.23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift
import FirebaseFirestore

      

struct LoginView: View {
    //MARK: User Details
    @State var emailID: String = ""
    @State var password: String = ""
    //MARK: View Properties
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    //MARK: User Defaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String=""
    @AppStorage("user_UID") var userUID: String = ""
    var body: some View {
        VStack(spacing: 10){
            Text("Lets Sign you in")
                .font(.largeTitle)
                .hAlign(.leading)
            
            Text("Welcome Back, \nYou have been missed")
                .font(.title3)
                .hAlign(.leading)
            
            VStack(spacing: 12){
                TextField("Email", text: $emailID )
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top,25)
                
                
                SecureField("Password", text: $password )
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                
                Button("Reset password", action: resetPassword )
                    .font(.callout)
                    .fontWeight(.medium)
                    .tint(.black)
                    .hAlign(.trailing)
                
                Button(action: loginUser) {
                    //MARK:Login Button
                    Text("Sign In")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillViwe(.black)
                    
                }
                .padding(.top,10)
            }
            
            // MARK: Register Button
            HStack{
                Text("Don´t have an Account?")
                    .foregroundColor(.gray)
                
                Button("Register Now"){
                    createAccount.toggle()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlgin(.bottom)
            
        }
        .vAlgin(.top)
        .padding(10)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        //MARK: Register View via Sheets
        .fullScreenCover(isPresented: $createAccount) {
            RegisterView()
            
        }
        //MARK
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    func loginUser(){
        isLoading  = true
        Task{
            do{
                //With the help of Swift Concurrency Auth can be done with Single Line
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("User Found")
                logStatus = true
                try await fetchUser()
            }catch{
              await  setError(error)
                
            }
        }
    }
    func resetPassword(){
        Task{
            do{
                //With the help of Swift Concurrency Auth can be done with Single Line
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("User Found")
            }catch{
              await  setError(error)
                
            }
        }
    }
    //MARK: If User if Found then Fetching From Firestore
    func fetchUser()async throws{
        guard let userID = Auth.auth().currentUser?.uid else{return}
        let user = try await Firestore.firestore().collection("User").document(userID).getDocument(as: User.self)
        //MARK: UI Updating Must be Run on Main Thread
        await MainActor.run(body: {
            //setting UserDefaults data and Changing App`s Auth Status
            userUID = userID
            userNameStored = user.username
            profileURL = user.userProfileURL
            logStatus = true
        })
    }
    
    func setError(_ error: Error) async{
        // MARK: UI Must be Updated on Mian Thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
            
        })
    }
}






struct LoginView_Previews: PreviewProvider{
    static var previews: some View {
    LoginView()
    }
}





