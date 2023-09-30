//
//  DailyCalenderView.swift
//  imonit
//
//  Created by 薗部拓人 on 2023/08/16.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedOption: CalendarOption = .daily
    @State private var selectedDate: Date = Date() // Current date by default

    let currentDate: Date = Date()
    @State var selectedMonth: Date = Date()
    var dateOfMonth: [Date] {
        generateDatesOfMonth(selectedMonth: selectedMonth)!
    }
    
    enum CalendarOption: String, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
        case yearly = "Yearly"
    }
    @State private var selectedCalender: CalendarOption = .weekly
    @State private var searchText: String = ""
    @State private var isSearching = false
    @State private var isPresentedMagnifyingglass = false
    @State private var isPresentedAddSchedule = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack(alignment: .top) {
            if isPresentedMagnifyingglass {
                Rectangle()
                    // fill system color mode
                    .fill(colorScheme == .dark ? .black : .white)
                    .frame(width: .infinity, height: .infinity)
                    .zIndex(1)
                    .ignoresSafeArea(edges: .all)
                    .transition(.move(edge: .top))
                    .overlay(alignment: .topLeading){
                        VStack(alignment: .leading) {
                            HStack {
                                TextField("Search", text: $searchText, prompt: Text("Placeholder").foregroundStyle(.gray))
                                    
                                Button("Cancel") {
                                    withAnimation {
                                        isPresentedMagnifyingglass.toggle()
                                    }
                                }
                            }
                            .textFieldStyle(.roundedBorder)
                            .padding()
                            
                            
                            ForEach(0..<10) { _ in
                               RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray)
                                .frame(height: 50)
                                .padding(.horizontal)
                            }
                        }
                    }
            }
              
            
        NavigationStack {
            VStack(alignment: .trailing){
                Group {
                    
                   
                }
                
                switch selectedCalender {
                case .daily:
                    CalendarDailyView(selectedDate: $selectedDate)
                case .weekly:
                    CalendarWeeklyView(currentDate: currentDate, selectedMonth: $selectedMonth, dateOfMonth: dateOfMonth)
                case .monthly:
                    Text("Monthly View")
                case .yearly:
                    Text("Yearly View")
                }
                    
            }
            .toolbar{
                ToolbarItemGroup {
                    HStack(alignment: .center, spacing: 0){
                        Button {
                            selectedMonth = Date()
                        } label: {
                            Text("Today")
                        }
                        
                        Spacer()
                        
                        Picker("Select a time interval", selection: $selectedCalender) {
                            ForEach(CalendarOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        //                    .containerRelativeFrame(.horizontal, count: 10, span: 5, spacing: 0)
                        .pickerStyle(.menu)
                        toolbar
                        
                        //                    .containerRelativeFrame(.horizontal, count: 10, span: 5, spacing: 0)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    }
    var toolbar: some View {
            
            
            HStack{
                // Search Schedules
                Button(action: {
                    withAnimation()  {
                        isPresentedMagnifyingglass.toggle()}
                }
                
                ) {
                    Image(systemName: "magnifyingglass")
                    //                    .font(.title2)
                    //                    .padding(.horizontal,5)
                }
                
                
                
                // Add New Schedules
                Button(action: {isPresentedAddSchedule.toggle()}) {
                    Image(systemName: "plus")
                    //                    .font(.title2)
                    //                    .padding(.horizontal,5)
                }
            }
            .sheet(isPresented: $isPresentedAddSchedule, content: {
                AddSchedule()
            })
            
    
    }


    
}

#Preview {
    CalendarView()
}



    
