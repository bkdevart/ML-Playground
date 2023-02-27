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
    
    var body: some View {
        TabView {
            controls.loadBMI()
                .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image(systemName: "chart.dots.scatter")
                        Text("BMI")
                    }
            
            controls.loadGlucose()
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "chart.dots.scatter")
                    Text("Glucose")
                }
        }
    }
}

struct StarterGraphs_Previews: PreviewProvider {
    static var previews: some View {
        StarterGraphs()
    }
}
