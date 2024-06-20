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
    
    let shared = UIJoin.shared
    
    var body: some View {
        TabView {
            
            // Scatterplot
            VStack {
                Text("Similar Samples")
                    .font(.largeTitle)
                shared.loadScatter()
                    .padding()
                // summary stats
                HStack {
                    shared.userTable
                    shared.summaryTable
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
                Text("by Positive/Negative Outcome")
                    .font(.subheadline)
                // chart
                shared.loadBar()
                    .padding()
                
                // outcome 0 and 1 summary stats
                HStack {
                    VStack {
                        Text("Negative")
                            .font(.headline)
                            .foregroundStyle(shared.categoryColors[0]!)
                        shared.summaryTable0
                    }
                    VStack {
                        Text("Positive")
                            .font(.headline)
                            .foregroundStyle(shared.categoryColors[1]!)
                        shared.summaryTable1
                    }
                }
                .font(.body)
            }
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .tabItem {
                Image(systemName: "chart.bar")
                Text("Bar")
            }
        }
        .navigationTitle("Detail")
    }
}

struct StarterGraphs_Previews: PreviewProvider {
    static var previews: some View {
        StarterGraphs()
    }
}
