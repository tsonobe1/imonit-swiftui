//
//  DailyScheduleView.swift
//  imonit
//
//  Created by 薗部拓人 on 2023/08/18.
//

import SwiftUI

struct CalendarDailyView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack{
            HStack {
                Text(formattedDate(date: selectedDate))
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: decrementDate) {
                    Image(systemName: "arrow.left")
                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: incrementDate) {
                    Image(systemName: "arrow.right")
                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }
    
    func incrementDate() {
        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
    }
    
    func decrementDate() {
        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

#Preview {
    CalendarDailyView(selectedDate: .constant(Date()))
}
