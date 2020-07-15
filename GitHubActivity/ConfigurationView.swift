//
//  ConfigurationView.swift
//  GitHubActivity
//
//  Created by Florin Pop on 14.07.20.
//  Copyright © 2020 Florin Pop. All rights reserved.
//


import Combine
import SwiftUI


struct ConfigurationView: View {
    @State private var loading: Bool = false
    @State private var error: String = ""
    @State private var user: String = ""
    @State private var goal: Float = 5
    @EnvironmentObject var configuration: Configuration
    
    var body: some View {
        Group {
            VStack {
                Text("Configuration")
                
                VStack (alignment: .center) {
                    HStack (alignment: .firstTextBaseline) {
                        TextField("GitHub user handle", text: $user).autocapitalization(.none)
                        .onReceive(configuration.$user) { self.user = $0 }
                    }
                    HStack {
                        Text("Daily contributions")
                        Slider(value: $goal, in: 1...50, step: 1)
                        .onReceive(configuration.$goal) { self.goal = $0 }
                    }
                    Text("\(Int(goal))")
                    Spacer()
                    Text(error).foregroundColor(.red)
                    Spacer()
                    
                }
            }
            Button(action: {
                self.loading = true
                self.error = ""
                loadContributions(of: self.user) { contributions, error in
                    DispatchQueue.main.async {
                        self.loading = false
                        if let error = error {
                            self.error = error
                        } else {
                            self.configuration.isConfigured = true
                            self.configuration.goal = self.goal
                            self.configuration.user = self.user
                            self.configuration.contributions = contributions
                        }
                    }
                }
            }) {
                Text("Continue")
            }.disabled(user.count == 0 || loading)
        }.padding()
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView().environmentObject(Configuration())
    }
}
