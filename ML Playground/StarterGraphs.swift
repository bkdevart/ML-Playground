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
    @State private var filterBMI = 75.0 // using a value that is not exceeded in chart to start, set to max later
    @State private var filterGlucose = 200.0 // ditto above
    
    var body: some View {
        TabView {
            // Glucose chart
            VStack {
                controls.loadGlucose()
                HStack {
                    Text("Glucose: \(String(format: "%.f", filterGlucose))")
                        .font(.body)
                    Slider(value: $filterGlucose, in: 0...200, step: 1)
                        .onChange(of: filterGlucose) { _ in
                            controls.filterGlucose = Float(filterGlucose)  // store value so it can be used to filter data
                            controls.loadGlucoseFilter()  // update data for graphs with filter
                        }
                }
                .padding()
            }
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .tabItem {
                Image(systemName: "chart.dots.scatter")
                Text("Glucose")
            }
            
            // BMI chart
            VStack {
                controls.loadBMI()
                HStack {
                    Text("BMI: \(String(format: "%.f", filterBMI))")
                        .font(.body)
                    Slider(value: $filterBMI, in: 0...75, step: 1)
                        .onChange(of: filterBMI) { _ in
                            controls.filterBMI = Float(filterBMI)
                            controls.loadBMIFilter()
                        }
                }
                .padding()
            }
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .tabItem {
                Image(systemName: "chart.dots.scatter")
                Text("BMI")
            }
        }
//        .onAppear(perform: {
//            controls.loadBMIFilter()
//            controls.loadGlucoseFilter()
//        })
    }
}

struct StarterGraphs_Previews: PreviewProvider {
    static var previews: some View {
        StarterGraphs()
    }
}
