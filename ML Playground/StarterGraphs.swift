//
//  StarterGraphs.swift
//  ML Slide
//
//  Created by Brandon Knox on 2/21/23.
//

import SwiftUI
import Charts
import UniformTypeIdentifiers

struct StarterGraphs: View {
    
    let controls = UIJoin.shared
    @State private var filterBMI = 32.0 // using a value that is not exceeded in chart to start, set to max later
    @State private var filterGlucose = 117.0 // ditto above
    
    
    var body: some View {
        TabView {
            
            // summary stats
            VStack {
                Text("Similar Samples")
                    .font(.largeTitle)
                Group {
//                    Text("Samples: \(controls.getSampleCount())")
//                    Text("Mean: \(controls.getGlucoseMean())")
                }
                .font(.body)
                controls.loadScatter()
                    .padding()
                // Glucose chart
//                HStack {
//                    Text("Max value: \(String(format: "%.f", filterGlucose))")
//                        .font(.body)
//                    Slider(value: $filterGlucose, in: 0...200, step: 1)
//                        .onChange(of: filterGlucose) { _ in
//                            controls.filterGlucose = Float(filterGlucose)
//                        }
//                }
//                .padding()
            }
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .tabItem {
                Image(systemName: "chart.dots.scatter")
                Text("Scatter")
            }
            
            // BMI chart
            VStack {
                Text("Sample Counts")
                    .font(.largeTitle)
                Text("by Outcome")
                    .font(.subheadline)
                // chart
                controls.loadBar()
                    .padding()
                
                // summary stats
                Group {
//                    Text("Samples: \(controls.getSampleCount())")
                    // TODO: add additional stats
                    controls.summaryTable
                }
                .font(.body)
            }
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .tabItem {
                Image(systemName: "chart.bar")
                Text("Bar")
            }
        }
        .onAppear(perform: {
//            controls.loadBMIFilter()
//            controls.loadGlucoseFilter()
        })
    }
}

struct StarterGraphs_Previews: PreviewProvider {
    static var previews: some View {
        StarterGraphs()
    }
}
