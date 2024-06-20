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
            
            // Scatterplot
            VStack {
                Text("Similar Samples")
                    .font(.largeTitle)
                controls.loadScatter()
                    .padding()
                // summary stats
                Group {
                    controls.summaryTable
                }
            }
            .tabItem {
                Image(systemName: "chart.dots.scatter")
                Text("Scatter")
            }
            
            // Bar chart
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
                    // add additional stats
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
