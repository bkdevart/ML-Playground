//
//  StarterGraphs.swift
//  ML Slide
//
//  Created by Brandon Knox on 2/21/23.
//

import SwiftUI
import Charts

// TODO: make this view tabular so you can view different graphs

// https://developer.apple.com/documentation/charts/creating-a-chart-using-swift-charts
struct ToyShape: Identifiable {
    var type: String
    var count: Double
    var id = UUID()
}

// TODO: load from csv file
var data: [ToyShape] = [
    .init(type: "Cube", count: 5),
    .init(type: "Sphere", count: 4),
    .init(type: "Pyramid", count: 4)
]

struct BarChart: View {
    var body: some View {
        Chart {
            BarMark(
                    x: .value("Shape Type", data[0].type),
                    y: .value("Total Count", data[0].count)
                )
                BarMark(
                     x: .value("Shape Type", data[1].type),
                     y: .value("Total Count", data[1].count)
                )
                BarMark(
                     x: .value("Shape Type", data[2].type),
                     y: .value("Total Count", data[2].count)
                )
        }
    }
}


struct StarterGraphs: View {
    var body: some View {
        BarChart()
    }
}

struct StarterGraphs_Previews: PreviewProvider {
    static var previews: some View {
        StarterGraphs()
    }
}
