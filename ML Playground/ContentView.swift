//
//  ContentView.swift
//  ML Playground
//
//  Created by Brandon Knox on 2/16/23.

import SwiftUI
import CoreML

struct ContentView: View {
//    @State private var wakeUp = Date.now
//    @State private var sleepAmount = 8.0
//    @State private var coffeeAmount = 1
    @State private var predictionValue = 0
    
    @State private var pregnancies = -0.855471
    @State private var glucose = 0.007329
    @State private var bloodPressure = 0.472598
    @State private var skinThickness = 1.152080
    @State private var insulin = -0.036333
    @State private var BMI = 0.883020
    @State private var diabetesPedigreeFunction = -0.658457
    @State private var Age = -0.466486
//    let model = SleepCalculator()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Classification Result")
                    .font(.headline)
                Text("\(predictionValue)")
                    .font(.largeTitle)
                Spacer()

//                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
//                    .labelsHidden()

                Text("Choose feature values")
                    .font(.headline)
                Group {
                    HStack {
                        Text("Pregnancy: \(pregnancies)")
                        Slider(value: $pregnancies, in: -2...4, step: 0.05)
                    }
                    
                    HStack {
                        Text("Glucose: \(glucose)")
                        Slider(value: $glucose, in: -4...3, step: 0.05)
                    }
                    
                    HStack {
                        Text("Blood Pressure: \(bloodPressure)")
                        Slider(value: $bloodPressure, in: -4...3, step: 0.05)
                    }

                    HStack {
                        Text("Skin Thickness: \(skinThickness)")
                        Slider(value: $skinThickness, in: -2...5, step: 0.05)
                    }
                }
                Group {
                    HStack {
                        Text("Insulin: \(insulin)")
                        Slider(value: $insulin, in: -1...7, step: 0.05)
                    }
                    
                    HStack {
                        Text("BMI: \(BMI)")
                        Slider(value: $BMI, in: -4...5, step: 0.05)
                    }
                    
                    HStack {
                        Text("Diabetes Pedigree Function: \(diabetesPedigreeFunction)")
                        Slider(value: $diabetesPedigreeFunction, in: -2...6, step: 0.05)
                    }
                    
                    HStack {
                        Text("Age: \(Age)")
                        Slider(value: $Age, in: -1...4, step: 0.05)
//                            .onChange(of: Age, perform: calculateDiabetes)
                    }
                    
                }
                Text("Note: values are scaled currently")
                Spacer()
            }
            .navigationTitle("Diabetes Test")
            .padding([.horizontal])
            .toolbar {
                Button("Calculate", action: calculateDiabetes)
            }
        }
    }
    
    func calculateDiabetes() {
        do {
            let config = MLModelConfiguration()
            let model = try DiabetesTest(configuration: config)

            // predict
            /* Pregnancies  0.050877 -0.855471
             Glucose 0.133338 0.007329
             BloodPressure 0.579644 0.472598
             SkinThickness -1.306391  1.152080
             Insulin -0.725848 -0.036333
             BMI 0.029973 0.883020
             DiabetesPedigreeFunction 0.167620 -0.658457
             Age -0.550743 -0.466486
             */
            // took first row from scaled training set to test
            let prediction = try model.prediction(Pregnancies: pregnancies, Glucose: glucose, BloodPressure: bloodPressure, SkinThickness: skinThickness, Insulin: insulin, BMI: BMI, DiabetesPedigreeFunction: diabetesPedigreeFunction, Age: Age)
            // TODO: figure out how to assign this
            predictionValue = Int(prediction.Outcome)
            print(predictionValue)
            // more code here
        } catch {
            // something went wrong!
        }
    }
}
