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
 1. Modify Near output on slider to show % total sample visualized represents
 2. Make ability to train on more data?
    a. My current understanding is that this can't be done, but verify
 3. Visualize other model parameters
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
    @State private var sampleSize = 768
    
    let shared = UIJoin.shared

    
    var body: some View {
        let textColor = shared.categoryColors[predictionValue, default: .black]
        
        NavigationView {
            
            VStack {
                Text("Classification Result")
                    .font(.headline)
                
                let displayText = predictionValue == 0 ? "Negative" : "Positive"
                Text("\(displayText)")
                    .font(.largeTitle)
                    .foregroundColor(textColor)
                HStack {
                    // TODO: see if you can get data to load here
                    shared.loadScatter()
                    shared.loadBar()
                }
                VStack {
                    // TODO: add sample size # to this output
                    Text("Sample size: \(String(format: "%.1f", (Float(shared.getSampleCount()) / 768.0) * 100))%")
                    HStack {
                        Text("Neighboring data")
                        Slider(value: $percentNear, in: 0...100, step: 1)
                            .onChange(of: percentNear) { _ in
                                shared.filterPercentNear = Float(percentNear)
                                shared.calcFeaturePercent(percentNet: percentNear)
                                calculateDiabetes()
                            }
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
                                        shared.calcFeaturePercent(percentNet: shared.filterPercentNear)
                                        calculateDiabetes()
                                    }
                            }
                            
                            VStack {
                                Text("Blood Pressure: \(String(format: "%.f", bloodPressure))")
                                Slider(value: $bloodPressure, in: 0...122, step: 1)
                                    .onChange(of: bloodPressure) { _ in
                                        shared.filterBloodPressure = Float(bloodPressure)
                                        shared.calcFeaturePercent(percentNet: shared.filterPercentNear)
                                        calculateDiabetes()
                                    }
                            }
                            
                            VStack {
                                Text("Skin Thickness: \(String(format: "%.2f", skinThickness))")
                                Slider(value: $skinThickness, in: 0...100, step: 0.05)
                                    .onChange(of: skinThickness) { _ in
                                        shared.filterSkinThickness = Float(skinThickness)
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
                                        shared.calcFeaturePercent(percentNet: shared.filterPercentNear)
                                        calculateDiabetes()
                                    }
                            }
                            
                            VStack {
                                Text("BMI: \(String(format: "%.1f", BMI))")
                                Slider(value: $BMI, in: 0...67, step: 0.5)
                                    .onChange(of: BMI) { _ in
                                        shared.filterBMI = Float(BMI)
                                        shared.calcFeaturePercent(percentNet: shared.filterPercentNear)
                                        calculateDiabetes()
                                    }
                            }
                            
                            VStack {
                                Text("DPF: \(String(format: "%.2f", diabetesPedigreeFunction))")
                                Slider(value: $diabetesPedigreeFunction, in: 0.0...2.5, step: 0.05)
                                    .onChange(of: diabetesPedigreeFunction) { _ in
                                        shared.filterdiabetesPedigreeFunction = Float(diabetesPedigreeFunction)
                                        shared.calcFeaturePercent(percentNet: shared.filterPercentNear)
                                        calculateDiabetes()
                                    }
                            }
                            
                            VStack {
                                Text("Age: \(String(format: "%.f", Age))")
                                Slider(value: $Age, in: 21...81, step: 1)
                                    .onChange(of: Age) { _ in
                                        shared.filterAge = Float(Age)
                                        shared.calcFeaturePercent(percentNet: shared.filterPercentNear)
                                        calculateDiabetes()
                                    }
                            }
//                            Spacer()
                        }
                    }
                }
            }
//            .navigationTitle("ML Model")
            .padding([.horizontal])
            .toolbar {
                NavigationLink("Detail", destination: StarterGraphs())
            }
            .onAppear {
                shared.loadData()
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
