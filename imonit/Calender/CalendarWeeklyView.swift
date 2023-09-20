//
//  scroll7.swift
//  imonit
//
//  Created by 薗部拓人 on 2023/08/26.
//

import SwiftUI

struct CalendarWeeklyView: View {
    let events = createEvents()
    
    var hourHeight: CGFloat = 90
    var headerHeight: CGFloat = 60

    @State private var offset = CGPoint.zero
    
    let currentDate = Date() // 現在の日付を取得
    @State var dateList: [Date] = []
    @State var selectedMonth: Date = Date()
    var dateOfMonth: [Date] {
     generateDatesOfMonth(selectedMonth: selectedMonth)!
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Color.clear.frame(height: headerHeight)
                    ScrollView([.vertical]) {
                        TimeColumnHeader(
                            currentDate: currentDate,
                            hourHeight: hourHeight
                        )
                        .offset(y: offset.y)
                    }
                    .disabled(true)
                    .offset(y: -hourHeight/4)
                    .scrollIndicators(.hidden)
                }
                .containerRelativeFrame(.horizontal, count: 10, span: 1, spacing: 0)
                
                VStack(alignment: .leading, spacing: 0) {
                    ScrollView([.horizontal]) {
                        DateRowHeader(
                            dateList: $dateList,
                            headerHeight: headerHeight,
                            currentDate: currentDate
                        )
                        .offset(x: offset.x)
                    }
                    .disabled(true)
                    ScheduleTable(
                        dateList: $dateList,
                        offset: $offset,
                        headerHeight: headerHeight,
                        hourHeight: hourHeight,
                        currentDate: currentDate
                    )
                    .coordinateSpace(.named("scroll"))
                }
                .containerRelativeFrame(.horizontal, count: 10, span: 9, spacing: 0)
            }
            .onAppear {
                let _ = print("appear!!!!!")
                let calendar = Calendar.current
                
                // 今日が含まれる月の初日を求める
                if let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: currentDate))) {
                    
                    // 月の最終日を求める
                    if let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) {
                        
                        // 月の初日から最終日まで日付をリストに追加
                        var currentDate = startOfMonth
                        while currentDate <= endOfMonth {
                            dateList.append(currentDate)
                            
                            // 次の日に移動（失敗した場合はループを終了）
                            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                                currentDate = nextDate
                            } else {
                                break
                            }
                        }
                    }
                }
            }
        }
    }
}


struct DateRowHeader: View {
    @Binding var dateList: [Date]
    var headerHeight: CGFloat
    let currentDate: Date
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(dateList, id: \.self) { day in
                // Daily
                dateHeaderText(day: day)
                    .overlay(alignment: .bottomLeading){
                        dateHeaderBorder
                    }
            }
        }
    }
    
    func dateHeaderText(day: Date) -> some View {
        HStack(alignment: .lastTextBaseline , spacing: 5){
            Text(DateFormatter.monthFormatter.string(from: day))
            VStack{
                Text(DateFormatter.weekdayFormatter.string(from: day))
                    .font(.caption)
                Text(DateFormatter.dayFormatter.string(from: day))
                    .font(.title3)
                    .bold()
            }
        }
        .foregroundStyle(Calendar.current.isDate(day, equalTo: currentDate, toGranularity: .day) ? .red : .primary)
        .frame(height: headerHeight)
        .containerRelativeFrame(.horizontal, count: 7, span: 3, spacing: 0)
    }
    
    var dateHeaderBorder: some View{
        VStack(alignment: .leading, spacing: 0){
            Rectangle()
                .frame(width: 1)
                .opacity(0.3)
            Rectangle()
                .frame(height: 1)
                .opacity(0.2)
        }
    }
}

struct TimeColumnHeader: View {
    var currentDate: Date
    var hourHeight: CGFloat
    
    var body: some View {
        timeColumn24Label
            .overlay(alignment: .topLeading){
                currentTime
            }
    }
    
    var timeColumn24Label: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0...23, id: \.self) { hour in
                Color.clear
                    .frame(height: hourHeight)
                    .overlay(alignment: .center){
                        Text("\(String(format: "%02d", hour)):00")
                            .font(.caption2)
                            .offset(y: -hourHeight/4)
                            .opacity(0.8)
                    }
            }
        }
    }
    
    var currentTime: some View {
        GeometryReader { proxy in
            HStack(alignment: .center, spacing: 0){
                Text("\(formatTime(from: currentDate))")
                    .font(.caption2)
                    .foregroundStyle(.red)
                Spacer()
            }
            .offset(y: hourHeight/4 + (proxy.frame(in: .global).height / 1440 * dateToMinute(date: currentDate)) - 7)
            .frame(width: 100)
        }
    }
}

struct ScheduleTable: View {
    
    @Binding var dateList: [Date]
    @Binding var offset: CGPoint
    
    var headerHeight: CGFloat
    var hourHeight: CGFloat
    let currentDate: Date
    var positionInCurrentMonth: CGFloat? {
        if let datePosition = currentDate.positionInCurrentMonth() {
            datePosition
        } else {
            nil
        }
    }
    var positionInCurrentDay: CGFloat?{
        if let position = currentDate.positionInCurrentDay() {
            position
        } else {
            nil
        }
    }
    
    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            LazyHStack(alignment: .top, spacing: 0) {
                
                ForEach(dateList, id: \.self) { day in
                    TableView(dateList: $dateList, day: day, hourHeight: hourHeight)
                }
                
            }
            .overlay(alignment: .topLeading){
                currentTimeDivider
            }
            .scrollTargetLayout()
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: ViewOffsetKey.self, value: geo.frame(in: .named("scroll")).origin)
                }
            )
            .onPreferenceChange(ViewOffsetKey.self) { value in
                //                print("offset >> \(value)")
                offset = value
            }
            
        }
        .defaultScrollAnchor(.some(UnitPoint(x: positionInCurrentMonth ?? 0, y: positionInCurrentDay ?? 0)))
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        //TODO: scrollPositionを使うと横スクロールの挙動がバグるのでひとまず無効にしておく
        //        .scrollPosition(id: $scrollPosition)
    }
    
    var currentTimeDivider: some View{
        GeometryReader { proxy in
            HStack(spacing: 0){
                Text("00:00 ")
                    .font(.caption2)
                    .foregroundStyle(.red)
                    .opacity(0.0)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.red)
            }
            .offset(y: (proxy.frame(in: .global).height / 1440 * dateToMinute(date: currentDate) - 7))
        }
    }
}

struct TableView: View {
    @State private var isLoading: Bool = false
    let events = createEvents()
    
    @Binding var dateList: [Date]
    var day: Date
    var hourHeight: CGFloat
    
    var body: some View {
//        let _ = Self._printChanges()
        
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0...23, id: \.self) { hour in
                tableCell(hour: hour, day: day)
            }
        }
        .overlay(alignment: .topLeading){
            scheduleBoxes()
        }
    }
    
    func tableCell(hour: Int, day: Date) -> some View{
        Group{
            ZStack(alignment: .topLeading){
                Rectangle()
                    .frame(height: 1)
                Rectangle()
                    .frame(width: 1)
            }
            .opacity(0.2)
        }
        .frame(height: hourHeight)
        .containerRelativeFrame(.horizontal, count: 7, span: 3, spacing: 0)
        .id("\(hour)_\(day)")
//        .onAppear{ handleItemAppearance(item: day) }
    }
    
    func scheduleBoxes() -> some View {
        let matchingSchedules = getMatchingSchedules(for: day, from: events)
        
        return GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                ForEach(matchingSchedules, id: \.title) { event in
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.blue.gradient)
                        .opacity(0.4)
                        .overlay {
                            Text(event.title)
                                .bold()
                        }
                        .frame(height: proxy.frame(in: .global).height / 1440 * caluculateTimeInterval(startDate: event.startDate, endDate: event.endDate))
                        .offset(y: proxy.frame(in: .global).height / 1440 * dateToMinute(date: event.startDate))
                        .onTapGesture {
                            print(event.title)
                        }
                }
            }
        }
    }
    
    /// Filters and returns schedules that occur on a given day.
    /// - Parameters:
    ///   - day: The day for which to find schedules.
    ///   - schedules: The list of all schedules.
    /// - Returns: An array of schedules that occur on the given day.
    private func getMatchingSchedules(for day: Date, from schedules: [Schedule]) -> [Schedule] {
        let calendar = Calendar.current
        let currentDay = calendar.startOfDay(for: day)
        return schedules.filter { schedule in
            scheduleMatchesDay(schedule, on: currentDay, using: calendar)
        }
    }
    
    /// Checks if a schedule occurs on a given day.
    /// - Parameters:
    ///   - schedule: The schedule to check.
    ///   - day: The day to check against.
    ///   - calendar: The calendar to use for date calculations.
    /// - Returns: A Boolean value indicating whether the schedule occurs on the given day.
    private func scheduleMatchesDay(_ schedule: Schedule, on day: Date, using calendar: Calendar) -> Bool {
        let startDay = calendar.startOfDay(for: schedule.startDate)
        let endDay = calendar.startOfDay(for: schedule.endDate)
        return startDay <= day && day <= endDay
    }
    
    /// Handles the appearance of a new item in the date list.
    /// - Parameter item: The date item that appeared.
    private func handleItemAppearance(item: Date) {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { (t) in
            DispatchQueue.main.async {
                
                if item == dateList.last {
                    updateDateList(byAdding: 1)
                } else if item == dateList.first {
                    updateDateList(byAdding: -1)
                    
                }
            }
        }
    }
    
    /// Updates the date list by appending or prepending a new date.
    /// - Parameter daysToAdd: The number of days to add. Positive to append, negative to prepend.
    private func updateDateList(byAdding daysToAdd: Int) {
        guard !isLoading else { return }
        isLoading = true
        
        if let referenceDate = daysToAdd > 0 ? dateList.last : dateList.first,
           let newDate = Calendar.current.date(byAdding: .day, value: daysToAdd, to: referenceDate) {
            if daysToAdd > 0 {
                dateList.append(newDate)
            } else {
                dateList.insert(newDate, at: 0)
            }
        }
        isLoading = false
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGPoint
    static var defaultValue = CGPoint.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.x += nextValue().x
        value.y += nextValue().y
    }
}

#Preview {
    CalendarWeeklyView()
}

