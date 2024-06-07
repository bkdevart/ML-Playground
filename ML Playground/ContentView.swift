//
//  ContentView.swift
//  ML Playground
//
//  Created by Brandon Knox on 2/16/23.

import SwiftUI
import CoreML
import CreateMLComponents


/*
 FEATURE IDEAS
 1. Play with data visualization libraries to show density, etc
 2. Create more advanced visualizations with feature importances
 3. Make ability to train on more data? (much later)
    a. My current understanding is that this can't be done, but verify
 
 BUGS
 1. When submitting to TestFlight
    a. The provided entity includes a relationship with an invalid value
    b. '' not a valid id for the relatsionship 'build' (ID: d300770c-d5cb-46e6-ab2f-444845d0be6f)
 */

struct ContentView: View {
    @State private var predictionValue = 0
    
    @State private var percentNear : Float = 25.0 
    @State private var pregnancies = 3.0
    @State private var glucose = 117.0
    @State private var bloodPressure = 72.0
    @State private var skinThickness = 23.0
    @State private var insulin = 30.5
    @State private var BMI = 32.0
    @State private var diabetesPedigreeFunction = 0.3725
    @State private var Age = 29.0
    
    let shared = UIJoin.shared
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Classification Result")
                    .font(.headline)
                Text("\(predictionValue)")
                    .font(.largeTitle)
                HStack {
                    shared.loadScatter()
                    shared.loadBar()
                }
                
                Text("Choose feature values")
                    .font(.headline)
                Group {
                    
                    HStack {
                        Text("% Near: \(String(format: "%.f", percentNear))")
                        Slider(value: $percentNear, in: 0...100, step: 1)
                            .onChange(of: percentNear) { _ in
                                shared.calcFeaturePercent(percentNet: percentNear)
                                shared.filterPercentNear = Float(percentNear)  // store value so it can be used to filter data
//                                shared.loadFilters()  // update data for graphs with filter
                                calculateDiabetes()
                            }
                    }
                    
                    HStack {
                        Text("Pregnancy: \(String(format: "%.f", pregnancies))")
                        Slider(value: $pregnancies, in: 0...17, step: 1)
                            .onChange(of: pregnancies) { _ in
                                shared.filterPregancies = Float(pregnancies)
                                shared.loadFilters()
                                calculateDiabetes()
                            }
                    }
                    
                    HStack {
                        Text("Glucose: \(String(format: "%.f", glucose))")
                        Slider(value: $glucose, in: 0...200, step: 5)
                            .onChange(of: glucose) { _ in
                                shared.filterGlucose = Float(glucose)
                                shared.loadFilters()
                                calculateDiabetes()
                            }
                    }
                    
                    HStack {
                        Text("Blood Pressure: \(String(format: "%.f", bloodPressure))")
                        Slider(value: $bloodPressure, in: 0...122, step: 1)
                            .onChange(of: bloodPressure) { _ in
                                shared.filterBloodPressure = Float(bloodPressure)  // store value so it can be used to filter data
                                shared.loadFilters()  // update data for graphs with filter
                                calculateDiabetes()
                            }
                    }

                    HStack {
                        Text("Skin Thickness: \(String(format: "%.2f", skinThickness))")
                        Slider(value: $skinThickness, in: 0...100, step: 0.05)
                            .onChange(of: skinThickness) { _ in
                                shared.filterSkinThickness = Float(skinThickness)
                                shared.loadFilters()
                                calculateDiabetes()
                            }
                    }
                }
                Group {
                    HStack {
                        Text("Insulin: \(String(format: "%.f", insulin))")
                        Slider(value: $insulin, in: 0...846, step: 5)
                            .onChange(of: insulin) { _ in
                                shared.filterInsulin = Float(insulin)
                                shared.loadFilters()
                                calculateDiabetes()
                            }
                    }
                    
                    HStack {
                        Text("BMI: \(String(format: "%.1f", BMI))")
                        Slider(value: $BMI, in: 0...67, step: 0.5)
                            .onChange(of: BMI) { _ in   // can also be newBMI in BMI if you need value
                                shared.filterBMI = Float(BMI)
                                shared.loadFilters()
                                calculateDiabetes()
                            }
                    }
                    
                    HStack {
                        Text("Diabetes Pedigree Function: \(String(format: "%.2f", diabetesPedigreeFunction))")
                        Slider(value: $diabetesPedigreeFunction, in: 0.5...2.5, step: 0.05)
                            .onChange(of: diabetesPedigreeFunction) { _ in
                                shared.filterdiabetesPedigreeFunction = Float(diabetesPedigreeFunction)
                                shared.loadFilters()
                                calculateDiabetes()
                            }
                    }
                    
                    HStack {
                        Text("Age: \(String(format: "%.f", Age))")
                        Slider(value: $Age, in: 21...81, step: 1)
                            .onChange(of: Age) { _ in
                                shared.filterAge = Float(Age)
                                shared.loadFilters()
                                calculateDiabetes()
                            }
                    }
                    
                }
                Spacer()
            }
            .navigationTitle("Diabetes Test")
            .padding([.horizontal])
            .toolbar {
                NavigationLink("Graphs", destination: StarterGraphs())
            }
            .onAppear {
                shared.loadData()
                shared.loadBMIFilter()
                shared.loadFilters()
            }
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
