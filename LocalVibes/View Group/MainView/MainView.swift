//
//  MainView.swift
//  LocalVibes
//
//  Created by Florian Peters on 17.10.23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        //MARK: Tabview With Recent Post´s And Profile Tabs
        TabView{
            Text("Recent Post´s")
                .tabItem {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("Post´s")
                }
            
            ProfileView()
                .tabItem{
                    Image(systemName: "gear")
                    Text("Profile")
                }
        }
    }
}

#Preview {
    ContentView()
}
