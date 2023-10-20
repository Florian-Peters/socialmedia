
//
//  ContentView.swift
//  LocalVibes
//
//  Created by Florian Peters on 11.10.23.
//

import SwiftUI


struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        //MARK: Redicting User Based on Log
        if logStatus{
         MainView()
        }else{
          LoginView()
        }
      //  CreatNewPost{ _ in
      // }
    }
}

#Preview {
    ContentView()
}
