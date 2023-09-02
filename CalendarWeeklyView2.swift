//
//  CalendarWeeklyView.swift
//  imonit
//
//  Created by 薗部拓人 on 2023/08/18.
//

import SwiftUI

struct CalendarWeeklyView2: View {
    @Binding var selectedDate: Date
    @State var timelineHeihgt: Double = 50.0
    @State var magnifyBy: Double = 1.0
    
    var body: some View {
        // Timeline
        ScrollView {
            //MARK: Left Pain 横幅の比率はScrollViewの10%
            HourLabelsView(timelineHeihgt: $timelineHeihgt, magnifyBy: $magnifyBy)
            //MARK: Right Pain 横幅の比率はScrollViewの90%
                .overlay(alignment: .trailing){
                    DailySchedulesView(timelineHeihgt: $timelineHeihgt, magnifyBy: $magnifyBy)
                        .containerRelativeFrame(.horizontal, count: 10, span: 9, spacing: 0)
                }
        }
    }
}

/// `HourLabelsView` displays hourly labels on the left side of the calendar
struct HourLabelsView: View {
    @Binding var timelineHeihgt: Double
    @Binding var magnifyBy: Double
    
    var body: some View {
        VStack(spacing: 0){
            // Loop through each hour to create hourly labels
            ForEach(0..<24, id: \.self) { hour in
                // Hours xx:xx
                Text("\(String(format: "%02d", hour)):00")
                    .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 11.0, weight: .regular)))
                    .containerRelativeFrame(.horizontal, count: 10, span: 1, spacing: 0)
                    .frame(height: timelineHeihgt * magnifyBy)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

/// `DayilSchedulesView` displays calendar events for each hour of the day
struct DailySchedulesView: View {
//    @State var numberList: [Int] = [-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6]
    let currentDate = Date() // 現在の日付を取得
    @State var dateList: [Date] = [] // 空の日付配列を作成
    @State private var isLoading = false

    init(timelineHeihgt: Binding<Double>, magnifyBy: Binding<Double>) {
        self._timelineHeihgt = timelineHeihgt
        self._magnifyBy = magnifyBy
    }

    @Binding var timelineHeihgt: Double
    @Binding var magnifyBy: Double
    
    var body: some View {
        // Horizontal ScrollView to show X-weeks' worth of events
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0){
                // MARK: 📆 Scrollable Multi-Day Schedule
                ForEach(dateList, id: \.self) { date in
                    // Dividers
                    HStack(spacing: 0){
                        RoundedRectangle(cornerRadius: 10) // Vercical Divider
                            .frame(width: 1)
                            .foregroundStyle(.primary)
                            .opacity(0.3)
                            .offset(y: (timelineHeihgt * magnifyBy / 2))
                        HourlyScheduleGrid(timelineHeihgt: $timelineHeihgt, magnifyBy: $magnifyBy)
                            .overlay(alignment: .topLeading){
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.blue.gradient)
                                    .opacity(0.8)
                                    .frame(width: 100, height: 50)
                                    .offset(y: (timelineHeihgt * magnifyBy / 2))
                            }
                    }
                    .overlay(alignment: .top){
                        Text(DateFormatter.dayFormatter.string(from: date))
                            .font(.title3)
                            .bold()
                    }
                    .onAppear{
                        handleItemAppearance(item: date)
                    }
                    //MARK: 👉 Adjust the number of days displayed by changing values according to the device's horizontal width.
                    .containerRelativeFrame(.horizontal, count: 7, span: 4, spacing: 0)
                    // Mon 23, Tue 24, Wed 25 ......

                    
  
                }
            }
            // Modifier to horizontal scroll Daily Schedule one by one
            .scrollTargetLayout()
        }
        // Modifier to horizontal scroll Daily Schedule one by one
        .defaultScrollAnchor(.top)
        .scrollTargetBehavior(.viewAligned)
        .onAppear {
            // 今日を中心に前後7日（合計15日）の日付リストを作成
            for i in -16...16 {
                if let newDate = Calendar.current.date(byAdding: .day, value: i, to: currentDate) {
                    dateList.append(newDate)
                }
            }
        }
    }
    
    private func handleItemAppearance(item: Date) {
        if item == dateList.last {
            appendNewItems()
        } else if item == dateList.first {
            prependNewItems()
        }
    }

    private func appendNewItems() {
        guard !isLoading else { return }
        isLoading = true
        
        // dateList の最後の日付から1日後の日付を作成
        if let lastDate = dateList.last,
           let newDate = Calendar.current.date(byAdding: .day, value: 1, to: lastDate) {
            dateList.append(newDate)
        }
        
        isLoading = false
    }

    private func prependNewItems() {
        guard !isLoading else { return }
        isLoading = true
        
        // dateList の最初の日付から1日前の日付を作成
        if let firstDate = dateList.first,
           let newDate = Calendar.current.date(byAdding: .day, value: -1, to: firstDate) {
            dateList.insert(newDate, at: 0)
        }
        
        isLoading = false
    }
}

#Preview {
    CalendarWeeklyView2(selectedDate: .constant(Date()))
}



struct HourlyScheduleGrid: View {
    @Binding var timelineHeihgt: Double
    @Binding var magnifyBy: Double
    
    var body: some View {
        VStack(spacing: 0){
            // MARK: 📆 Daily Schedule
            ForEach(0..<24, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 10) // Horizontal Divider
                    .frame(height: timelineHeihgt * magnifyBy)
                    .foregroundStyle(.clear)
                    .overlay{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 1)
                            .foregroundColor(.primary)
                            .opacity(0.3)
                    }
            }
        }
    }
}
