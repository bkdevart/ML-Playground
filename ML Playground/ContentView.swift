//
//  ContentView.swift
//  ML Playground
//
//  Created by Brandon Knox on 2/16/23.

import SwiftUI

struct ContentView: View {

//    let model = SleepCalculator()
    
    var body: some View {
        NavigationView {
            Form {
//                Text("Sleep Time: \(alertMessage)")
//                    .font(.headline)
                
                Section (header: Text("When do you want to wake up?")
                            .font(.headline)) {

//                    DatePicker("Please enter a time",
//                               selection: $wakeUp,
//                               displayedComponents: .hourAndMinute)
//                        .labelsHidden()
//                        .datePickerStyle(WheelDatePickerStyle())
//                        .onChange(of: wakeUp) { newValue in calculateBedtime() }
                }
                
//                Section(header: Text("Desired amount of sleep")
//                            .font(.headline)) {
//
//                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
//                        Text("\(sleepAmount, specifier: "%g") hours")
//                    }
//                    .onChange(of: sleepAmount) { newValue in calculateBedtime() }
//                    .accessibility(value: Text("\(String(format: "%.2f", sleepAmount)) hours"))
//                }
                
//                Section(header: Text("Daily coffee intake")
//                            .font(.headline)) {
                    
//                    Picker("Coffee", selection: $coffeeAmount) {
//                        ForEach(1..<21) { cup in
//                            Text("\(cup) cups")
//                        }
//                    }
//                    .onChange(of: coffeeAmount) { newValue in calculateBedtime() }
                    
//                    Stepper(value: $coffeeAmount, in: 1...20) {
//                        if coffeeAmount == 1 {
//                            Text("1 cup")
//                        } else {
//                            Text("\(coffeeAmount) cups")
//                        }
//                    }
//                    .onChange(of: coffeeAmount) { newValue in calculateBedtime() }
//                    .accessibility(value: Text("\(coffeeAmount) cups"))
                }
            }
            .navigationBarTitle("BetterRest")
        }
    }
