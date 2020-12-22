//
//  Configuration.swift
//  GitHubActivity
//
//  Created by Florin Pop on 15.07.20.
//  Copyright © 2020 Florin Pop. All rights reserved.
//

import Combine
import SwiftUI

class Configuration: ObservableObject {
    @Published var user: String = "" {
        didSet {
            UserDefaults.standard.set(self.user, forKey: "github.user")
            UserDefaults.standard.synchronize()
        }
    }

    @Published var isConfigured: Bool
    @Published var goal: Float = 5 {
        didSet {
            UserDefaults.standard.set(self.goal, forKey: "contributions.goal")
            UserDefaults.standard.synchronize()
        }
    }

    @Published var contributions: [String: Contribution]!

    init() {
        if let goal = UserDefaults.standard.value(forKey: "contributions.goal") as? Float {
            self.goal = goal
        }

        if let user = UserDefaults.standard.value(forKey: "github.user") as? String {
            self.isConfigured = true
            self.user = user
            loadContributions(of: self.user) { contributions, _ in
                DispatchQueue.main.async {
                    self.contributions = contributions
                }
            }
        } else {
            self.isConfigured = false
        }
    }
}
