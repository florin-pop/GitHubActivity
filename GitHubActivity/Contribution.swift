//
//  Contribution.swift
//  GitHubActivity
//
//  Created by Florin Pop on 13.07.20.
//  Copyright © 2020 Florin Pop. All rights reserved.
//

import SwiftUI

struct Contribution {
    let count: Int
    let date: String
}

@discardableResult func loadContributions(of user: String, completion: @escaping (_ contributions: [String: Contribution], _ error: String?) -> Void) -> URLSessionTask? {
    guard let url = URL(string: "https://github.com/users/\(user)/contributions") else {
        completion([:], "could not prepare the request URL")
        return nil
    }

    let request = URLRequest(url: url)

    let task = URLSession.shared.dataTask(with: request) { data, _, downloadError in
        if let data = data, let textContent = String(data: data, encoding: .utf8), downloadError == nil {
            if textContent == "Not Found" {
                completion([:], "user not found")
                return
            }
            let searchedRange = NSRange(location: 0, length: textContent.lengthOfBytes(using: .utf8))
            let pattern = "(\" data-count=\")([^\"]{1,})(\" data-date=\")([^\"]{10})(\"/>)"

            guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
                completion([:], "could not prepare the regular exception for matching contributions")
                return
            }

            var contributions: [String: Contribution] = [:]
            let matches = regex.matches(in: textContent, options: .reportProgress, range: searchedRange)
            for match in matches {
                let data = String(textContent[Range(match.range(at: 2), in: textContent)!])
                let date = String(textContent[Range(match.range(at: 4), in: textContent)!])

                contributions[date] = Contribution(count: Int(data)!, date: date)
            }
            completion(contributions, nil)
        } else {
            completion([:], downloadError?.localizedDescription)
        }
    }
    task.resume()
    return task
}

// https://stackoverflow.com/a/56874327
private extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
