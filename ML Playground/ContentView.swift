//
//  ContentView.swift
//  ML Playground
//
//  Created by Brandon Knox on 2/16/23.

import SwiftUI
import CoreML
import CreateMLComponents

// FEATURE IDEAS
/*
 1. Play with data visualization libraries to show density, etc
 2. Create more advanced visualizations with feature importances
 3. Make ability to train on more data? (much later)
    a. My current understanding is that this can't be done, but verify
 */

struct ContentView: View {
    @State private var predictionValue = 0
    
    @State private var pregnancies = 0.0
    @State private var glucose = 70.0
    @State private var bloodPressure = 70.0
    @State private var skinThickness = 50.0
    @State private var insulin = 440.0
    @State private var BMI = 33.0
    @State private var diabetesPedigreeFunction = 0.5
    @State private var Age = 21.0
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Classification Result")
                    .font(.headline)
                Text("\(predictionValue)")
                    .font(.largeTitle)
                Spacer()

                Text("Choose feature values")
                    .font(.headline)
                Group {
                    HStack {
                        Text("Pregnancy: \(String(format: "%.f", pregnancies))")
                        Slider(value: $pregnancies, in: 0...17, step: 1)
                            .onChange(of: pregnancies) { _ in
                                calculateDiabetes()
                            }
                    }
                    
                    HStack {
                        Text("Glucose: \(String(format: "%.f", glucose))")
                        Slider(value: $glucose, in: 0...200, step: 5)
                            .onChange(of: glucose) { _ in
                                calculateDiabetes()
                            }
                    }
                    
                    HStack {
                        Text("Blood Pressure: \(String(format: "%.f", bloodPressure))")
                        Slider(value: $bloodPressure, in: 0...122, step: 1)
                            .onChange(of: bloodPressure) { _ in
                                calculateDiabetes()
                            }
                    }

                    HStack {
                        Text("Skin Thickness: \(String(format: "%.2f", skinThickness))")
                        Slider(value: $skinThickness, in: 0...100, step: 0.05)
                            .onChange(of: skinThickness) { _ in
                                calculateDiabetes()
                            }
                    }
                }
                Group {
                    HStack {
                        Text("Insulin: \(String(format: "%.f", insulin))")
                        Slider(value: $insulin, in: 0...846, step: 5)
                            .onChange(of: insulin) { _ in
                                calculateDiabetes()
                            }
                    }
                    
                    HStack {
                        Text("BMI: \(String(format: "%.1f", BMI))")
                        Slider(value: $BMI, in: 0...67, step: 0.5)
                            .onChange(of: BMI) { _ in   // can also be newBMI in BMI if you need value
                                calculateDiabetes()
                            }
                    }
                    
                    HStack {
                        Text("Diabetes Pedigree Function: \(String(format: "%.2f", diabetesPedigreeFunction))")
                        Slider(value: $diabetesPedigreeFunction, in: 0.5...2.5, step: 0.05)
                            .onChange(of: diabetesPedigreeFunction) { _ in
                                calculateDiabetes()
                            }
                    }
                    
                    HStack {
                        Text("Age: \(String(format: "%.f", Age))")
                        Slider(value: $Age, in: 21...81, step: 1)
                            .onChange(of: Age) { _ in
                                calculateDiabetes()
                            }
                    }
                    
                }
                Spacer()
            }
            .navigationTitle("Diabetes Test")
            .padding([.horizontal])
//            .toolbar {
//                Button("Calculate", action: calculateDiabetes)
//            }
        }
    }
    
    func calculateDiabetes() {
        do {
            let config = MLModelConfiguration()
            let model = try DiabetesTest(configuration: config)

            // predict
            let prediction = try model.prediction(Pregnancies: pregnancies, Glucose: glucose, BloodPressure: bloodPressure, SkinThickness: skinThickness, Insulin: insulin, BMI: BMI, DiabetesPedigreeFunction: diabetesPedigreeFunction, Age: Age)
            predictionValue = Int(prediction.Outcome)
            // more code here
        } catch {
            // something went wrong!
        }
    }
}
