//
//  ActivityView.swift
//  GitHubActivity
//
//  Created by Florin Pop on 27.05.20.
//  Copyright © 2020 Florin Pop. All rights reserved.
//

import SwiftUI
import KalendarView


struct ActivityView: View {
    @ObservedObject var selection = KalendarSelection()
    @State private var fromDate: Date = Date().addingTimeInterval(-60*60*24*365)
    @State private var toDate: Date = Date().addingTimeInterval(60*60*24*31)
    @EnvironmentObject var configuration: Configuration
    
    var body: some View {
        Group {
            KalendarView(fromDate: fromDate, toDate: toDate, scrollToBottom: true, selection: self.selection) { date in
                RingView(
                    percentage: .constant(self.getPercentage(date: date)),
                    backgroundColor: Color.ringBackground,
                    startColor: Color.ringStartColor,
                    endColor: Color.ringEndColor,
                    thickness: 4
                )
                    .animation(.easeOut)
                    .frame(width: 32, height: 32)
            }.sheet(isPresented: .constant(!configuration.isConfigured)) {
                ConfigurationView().environmentObject(self.configuration)
            }
            Button("Configure") {
                self.configuration.isConfigured = false
            }
        }
    }
    
    private func getColor(date: Date) -> Color {
        guard self.configuration.contributions != nil else { return .white }
        
        let contribution = self.configuration.contributions[dateFormatter.string(from: date)]
        return contribution?.color ?? .white
    }
    
    private func getPercentage(date: Date) -> Double {
        guard self.configuration.contributions != nil else { return 0.0 }
        
        let contribution = self.configuration.contributions[dateFormatter.string(from: date)]
        let percentage = Double(contribution?.count ?? 0) / Double(self.configuration.goal)
        return percentage
    }
}

private extension Color {
    static let ringBackground = Color(red: 1 / 255, green: 29 / 255, blue: 34 / 255)
    static let ringStartColor = Color(red: 0 / 255, green: 186 / 255, blue: 225 / 255)
    static let ringEndColor = Color(red: 0 / 255, green: 254 / 255, blue: 207 / 255)
}

private let dateFormatter: DateFormatter = {
    let _formatter =  DateFormatter()
    _formatter.timeZone = TimeZone(identifier: "UTC")
    _formatter.dateFormat = "yyyy-MM-dd"
    return _formatter
}()

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView().environmentObject(Configuration())
    }
}
