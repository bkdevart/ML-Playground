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
 1. Create more advanced visualizations with feature importances
 2. Add output for % distribution of diabetes/no diabetes for current feature selection
 2. Make ability to train on more data?
    a. My current understanding is that this can't be done, but verify
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
                VStack {
                    // TODO: add sample size # to this output
                    Text("Near: \(String(format: "%.f", percentNear))%")
                    Slider(value: $percentNear, in: 0...100, step: 1)
                        .onChange(of: percentNear) { _ in
                            shared.filterPercentNear = Float(percentNear)
                            shared.calcFeaturePercent(percentNet: percentNear)
                            calculateDiabetes()
                        }
                }
                
                Text("Choose feature values")
                    .font(.headline)
                
                HStack {
                    VStack {
                        Group {
                            VStack {
                                Text("Pregnancy: \(String(format: "%.f", pregnancies))")
                                Slider(value: $pregnancies, in: 0...17, step: 1)
                                    .onChange(of: pregnancies) { _ in
                                        shared.filterPregancies = Float(pregnancies)
                                        shared.calcFeaturePercent(percentNet: shared.filterPercentNear)
                                        calculateDiabetes()
                                    }
                            }
                            
                            VStack {
                                Text("Glucose: \(String(format: "%.f", glucose))")
                                Slider(value: $glucose, in: 0...200, step: 5)
                                    .onChange(of: glucose) { _ in
                                        shared.filterGlucose = Float(glucose)
                                        //                                shared.loadFilters()
                                        shared.calcFeaturePercent(percentNet: shared.filterPercentNear)
                                        calculateDiabetes()
                                    }
                            }
                            
                            VStack {
                                Text("Blood Pressure: \(String(format: "%.f", bloodPressure))")
                                Slider(value: $bloodPressure, in: 0...122, step: 1)
                                    .onChange(of: bloodPressure) { _ in
                                        shared.filterBloodPressure = Float(bloodPressure)  // store value so it can be used to filter data
                                        //                                shared.loadFilters()  // update data for graphs with filter
                                        shared.calcFeaturePercent(percentNet: shared.filterPercentNear)
                                        calculateDiabetes()
                                    }
                            }
                            
                            VStack {
                                Text("Skin Thickness: \(String(format: "%.2f", skinThickness))")
                                Slider(value: $skinThickness, in: 0...100, step: 0.05)
                                    .onChange(of: skinThickness) { _ in
                                        shared.filterSkinThickness = Float(skinThickness)
                                        //                                shared.loadFilters()
                                        shared.calcFeaturePercent(percentNet: shared.filterPercentNear)
                                        calculateDiabetes()
                                    }
                            }
                        }
                    }
                    VStack {
                        
                        Group {
                            VStack {
                                Text("Insulin: \(String(format: "%.f", insulin))")
                                Slider(value: $insulin, in: 0...846, step: 5)
                                    .onChange(of: insulin) { _ in
                                        shared.filterInsulin = Float(insulin)
                                        //                                shared.loadFilters()
                                        shared.calcFeaturePercent(percentNet: shared.filterPercentNear)
                                        calculateDiabetes()
                                    }
                            }
                            
                            VStack {
                                Text("BMI: \(String(format: "%.1f", BMI))")
                                Slider(value: $BMI, in: 0...67, step: 0.5)
                                    .onChange(of: BMI) { _ in   // can also be newBMI in BMI if you need value
                                        shared.filterBMI = Float(BMI)
                                        //                                shared.loadFilters()
                                        shared.calcFeaturePercent(percentNet: shared.filterPercentNear)
                                        calculateDiabetes()
                                    }
                            }
                            
                            VStack {
                                Text("DPF: \(String(format: "%.2f", diabetesPedigreeFunction))")
                                Slider(value: $diabetesPedigreeFunction, in: 0.5...2.5, step: 0.05)
                                    .onChange(of: diabetesPedigreeFunction) { _ in
                                        shared.filterdiabetesPedigreeFunction = Float(diabetesPedigreeFunction)
                                        //                                shared.loadFilters()
                                        shared.calcFeaturePercent(percentNet: shared.filterPercentNear)
                                        calculateDiabetes()
                                    }
                            }
                            
                            VStack {
                                Text("Age: \(String(format: "%.f", Age))")
                                Slider(value: $Age, in: 21...81, step: 1)
                                    .onChange(of: Age) { _ in
                                        shared.filterAge = Float(Age)
                                        //                                shared.loadFilters()
                                        shared.calcFeaturePercent(percentNet: shared.filterPercentNear)
                                        calculateDiabetes()
                                    }
                            }
                            Spacer()
                        }
                    }
                }
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
