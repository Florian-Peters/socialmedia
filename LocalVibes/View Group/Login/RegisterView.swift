//
//  RegisterView.swift
//  LocalVibes
//
//  Created by Florian Peters on 17.10.23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

//MARK: Register View
struct RegisterView: View{
    //MARK: User Details
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    @State var userBio: String = ""
    @State var userBioLink: String = ""
    @State var userProfilePicData: Data?
    //MARK: View Properties
    @Environment(\.dismiss) var dissmiss
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    //MARK: User Defaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String=""
    @AppStorage("user_UID") var userUID: String = ""
        var body: some View{
            VStack(spacing: 15){
                Text("Lets Register\nAccount")
                    .font(.largeTitle)
                    .hAlign(.leading)
                
                Text("Hello, have a wondergul journey")
                    .font(.title3)
                    .hAlign(.leading)
                
                //MARK: For Smaller Size Optimization
                ViewThatFits{
                    ScrollView(.vertical, showsIndicators: false){
                        HelperView()
                    }
                    
                   HelperView()
                }
                

                
                // MARK: Register Button
                HStack{
                    Text("Already have an Account?")
                        .foregroundColor(.gray)
                    Button("Login Now"){
                        dissmiss()
                        
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                }
                .font(.callout)
                .vAlgin(.bottom)
                
            }
            .vAlgin(.top)
            .padding(10)
            .overlay(content:{
                LoadingView(show: $isLoading)
            })
            .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
            .onChange(of: photoItem) {
                //MARK: Extracting UIMage From PhotoItem
                if let photoItem{
                    Task{
                        do{
                            guard let imageData = try await photoItem.loadTransferable(type: Data.self)
                            else{return}
                            //Mark:UI Must be Updated on Main Thread
                            await MainActor.run(body: {
                                userProfilePicData = imageData
                            })
                        }
                    }
                }
                
            }
            //MARK: Displaying Alert
            .alert(errorMessage, isPresented: $showError) {}
       
        }
    @ViewBuilder
    func HelperView()->some View{
        VStack(spacing: 12){
            ZStack{
                if let userProfilePicData,let image = UIImage(data: userProfilePicData){
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }else{
                    Image("NullProfile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                
            }
            .frame(width: 85, height: 85)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .contentShape(Circle())
            .onTapGesture {
                showImagePicker.toggle()
            }
            
            TextField("Username", text: $userName )
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .padding(.top,25)
            
            TextField("Email", text: $emailID )
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            SecureField("Password", text: $password )
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            TextField("About You", text: $userBio,axis: .vertical)
                .frame(minHeight: 100,alignment: .top)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            TextField("Bio Link (Optional)", text: $userBio )
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            Button(action: registerUser) {
                //MARK:Login Button
                Text("Sign up")
                    .foregroundColor(.white)
                    .hAlign(.center)
                    .fillViwe(.black)
                
            }
            .disableWithOpacity(userName == "" || userBio == "" || emailID == "" || password == "" || userProfilePicData == nil)
            .padding(.top,10)
        }
    }
    func registerUser(){
        isLoading = true
        closeKeyboard()
        Task{
            do{
                //Step 1: Creating Firebase Account
                try await Auth.auth().createUser(withEmail: emailID, password: password)
                // Step2: Uploading Profile Photo Into Firebase Storage
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                guard let imageData = userProfilePicData else{return}
                let storageRef = Storage.storage().reference().child("Profiel_Images").child(userUID)
                let _ = try await storageRef.putDataAsync(imageData)
                // Step3: Downloading Photo URL
                let downloadURL = try await storageRef.downloadURL()
                //Step 4: Creating a user Firestore Object
                let user = User(username: userName, userBio: userBio, userBioLink: userBioLink, userUID: userUID, userEmail: emailID, userProfileURL: downloadURL)
                //Step 5: SAving User Doc into Firestore Database
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: {
                  error in
                    if error == nil{
                        //MARK: Print Saved Successfully
                        print("Saved Successfully")
                        self.userBio = userUID
                        profileURL = downloadURL
                        logStatus = true
                        
                    }
                })
                
            }catch{
                //MARK Deliting Created Account in Case of Failure
                await setError(error)
            }
        }
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

#Preview {
    ContentView()
}
