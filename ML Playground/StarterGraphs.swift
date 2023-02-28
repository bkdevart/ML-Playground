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
                    
                Slider(value: $filterGlucose, in: 0...200, step: 1)
                    .onChange(of: filterGlucose) { _ in
                        //                    filterGlucose()
                    }
            }
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .tabItem {
                Image(systemName: "chart.dots.scatter")
                Text("Glucose")
            }
            
            // BMI chart
            VStack {
                controls.loadBMI()
                Slider(value: $filterBMI, in: 0...75, step: 1)
                    .onChange(of: filterBMI) { _ in
                        //                    filterBMI()
                    }
            }
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .tabItem {
                Image(systemName: "chart.dots.scatter")
                Text("BMI")
            }
        }
    }
}

struct StarterGraphs_Previews: PreviewProvider {
    static var previews: some View {
        StarterGraphs()
    }
}
