import SwiftUI

struct PostView: View {
    @State private var createNewPost: Bool = false // Corrected variable name

    var body: some View {
        VStack {
            Text("Hello, World!")
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Use frame to center text
                .background(Color.white) // Add a background color

            Button(action: {
                createNewPost.toggle()
            }) {
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(13)
                    .background(Color.black) // Corrected background color
                    .clipShape(Circle()) // Use clipShape to make it circular
            }
            .padding(15)
            .background(Color.clear)
        }
        .fullScreenCover(isPresented: $createNewPost) {
          
            CreatNewPost { post in
              
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}

