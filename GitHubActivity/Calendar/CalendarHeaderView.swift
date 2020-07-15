//
//  CalendarHeaderView.swift
//  GitHubActivity
//
//  Created by Florin Pop on 28.05.20.
//  Copyright © 2020 Florin Pop. All rights reserved.
//

import SwiftUI

struct CalendarHeaderView : View {
    @Binding var title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).padding()
            HStack(alignment: .bottom) {
                ForEach(DateFormatter.weekdaySymbols, id: \.self) { weekday in
                    HStack {
                        Spacer()
                        Text(weekday).fitWidthInCalendarCell()
                        Spacer()
                    }
                }
            }
        }
    }
}

#if DEBUG
struct CalendarHeaderView_Previews : PreviewProvider {
    static var previews: some View {
        CalendarHeaderView(title: .constant("May 2020"))
    }
}
#endif
