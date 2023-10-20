//
//  CreatNewPost.swift
//  LocalVibes
//
//  Created by Florian Peters on 19.10.23.
//

import SwiftUI
import PhotosUI

struct CreatNewPost: View {
    // Callbacks
    var onPost: (Post)->()
    //Postproperties
    @State private var postText: String = ""
    @State private var postImageData: Data?
    //Stored user Data
    @AppStorage("user_profile_url") private var profileURL: URL?
    @AppStorage("user_name") private var userName: String = ""
    @AppStorage("user_UID") private var userUID: String = ""
    
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    @FocusState private var showKeyboard: Bool
    
    var body: some View {
        VStack{
            HStack{
                Menu{
                    Button("Chacel",role: .destructive ){
                        dismiss()
                    }
                }label: {
                    Text("Cancel")
                        .font(.callout)
                        .foregroundColor(.black)
                }
                .hAlign(.leading)
                
                Button(action: {}){
                    Text("Post")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical,6)
                        .background(.black,in: Capsule())
                }
                .disableWithOpacity(postText.isEmpty)
            }
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background{
                Rectangle()
                    .fill(.gray.opacity(0.05))
                    .ignoresSafeArea()
            }
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 15){
                    TextField("What´s happening?", text: $postText,axis:  .vertical)
                        .focused($showKeyboard)
                    
                    if let postImageData, let image = UIImage(data: postImageData){
                        GeometryReader{
                         let size = $0.size
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                        .clipped()
                        .frame(height: 220)
                }
                }
                .padding(15)
                
            }
            Divider()
            
            HStack{
                Button{
                    showImagePicker.toggle()
                    
                } label: {
                    Image(systemName: "photo.on.rectangle")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                .hAlign(.leading)
                
                Button("Done"){
                    showKeyboard = false
                    
                }
            }
            .padding(.horizontal,15)
            .padding(.vertical,10)
        }
        .vAlgin(.top)
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { oldValue, newValue in
            if let newValue{
                Task{
                    if let rawImageData = try? await newValue.loadTransferable(type: Data.self), let image = UIImage(data: rawImageData), let
                        compressedImageData = image.jpegData(compressionQuality: 0.5){
                        
                        await MainActor.run {
                            postImageData = compressedImageData
                            photoItem = nil
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CreatNewPost(){_ in
        
    }
}
