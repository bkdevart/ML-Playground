//
//  UIJoin.swift
//  ML Slide
//
//  Created by Brandon Knox on 2/24/23.
//

import SwiftUI
import Charts

// better design pattern may be at https://www.kodeco.com/11781349-understanding-data-flow-in-swiftui

struct Pima: Codable, Identifiable {
    let id: Int
    let Pregnancies: Float
    let Glucose: Float
    let BloodPressure: Float
    let SkinThickness: Float
    let Insulin: Float
    let BMI: Float
    let DiabetesPedigreeFunction: Float
    let Age: Float
    let Outcome: Float

    var BMIString: String { BMI.formatted(.number) }
    var GlucoseString: String { Glucose.formatted(.number) }
}


class UIJoin: ObservableObject {
    @Published var pima = [Pima]()
    @Published var filteredBMI = [Pima]()  // TODO: remove this
    @Published var filteredGlucose = [Pima]()
    @Published var filteredTable = [Pima]()
    
    @Published var filterBMI = Float(32)
    @Published var filterGlucose = Float(117)
    @Published var filterBloodPressure = Float(72)
    @Published var filterSkinThickness = Float(23)
    @Published var filterInsulin = Float(30.5)
    @Published var filterPregancies = Float(3)
    @Published var filterdiabetesPedigreeFunction = Float(0.3725)
    @Published var filterAge = Float(29)
    @Published var filterPercentNear = Float(25)
    @Published var categoryColors: [Int: Color] = [
        0: Color(red: 255 / 255, green: 190 / 255, blue: 247 / 255),
        1: .blue
    ]
    
    public func getSampleCount() -> Int {
        return filteredTable.count
    }
    
    public func getDataByPercent(percentNet: Float, values: [Float]) -> Float {
        let min = values.min() ?? 0
        let max = values.max() ?? 0
        let percent = ((max - min) / 100.0) * percentNet
        // figure out new range off of BMIPercent value (add and subtract)
        return percent
    }
    
    // a function that calculates 1% difference for every feature range
    public func calcFeaturePercent(percentNet: Float) {
        // Pregancy
        // Calculate ranges
        var values = pima.map({ $0.Pregnancies })
        var percent = getDataByPercent(percentNet: percentNet, values: values)
        var min = filterPregancies - percent
        var max = filterPregancies + percent
        // filter table data
        filteredTable = pima.filter{ $0.Pregnancies <= max }
        filteredTable = filteredTable.filter{ $0.Pregnancies >= min }
        
        // Glucose
        // Calculate ranges
        values = pima.map({ $0.Glucose })
        percent = getDataByPercent(percentNet: percentNet, values: values)
        min = filterGlucose - percent
        max = filterGlucose + percent
        // filter table data
        filteredTable = filteredTable.filter{ $0.Glucose <= max }
        filteredTable = filteredTable.filter{ $0.Glucose >= min }
        
        // Blood pressure
        // Calculate ranges
        values = pima.map({ $0.BloodPressure })
        percent = getDataByPercent(percentNet: percentNet, values: values)
        min = filterBloodPressure - percent
        max = filterBloodPressure + percent
        // filter table data
        filteredTable = filteredTable.filter{ $0.BloodPressure <= max }
        filteredTable = filteredTable.filter{ $0.BloodPressure >= min }
        
        // Skin Thickness
        // Calculate ranges
        values = pima.map({ $0.SkinThickness })
        percent = getDataByPercent(percentNet: percentNet, values: values)
        min = filterSkinThickness - percent
        max = filterSkinThickness + percent
        // filter table data
        filteredTable = filteredTable.filter{ $0.SkinThickness <= max }
        filteredTable = filteredTable.filter{ $0.SkinThickness >= min }
        
        // Insulin
        // Calculate ranges
        values = pima.map({ $0.Insulin })
        percent = getDataByPercent(percentNet: percentNet, values: values)
        min = filterInsulin - percent
        max = filterInsulin + percent
        // filter table data
        filteredTable = filteredTable.filter{ $0.Insulin <= max }
        filteredTable = filteredTable.filter{ $0.Insulin >= min }
        
        // BMI
        // Calculate ranges
        values = pima.map({ $0.BMI })
        percent = getDataByPercent(percentNet: percentNet, values: values)
        min = filterBMI - percent
        max = filterBMI + percent
        // filter table data
        filteredTable = filteredTable.filter{ $0.BMI <= max }
        filteredTable = filteredTable.filter{ $0.BMI >= min }
        
        // Diabetes Pedigree Function
        // Calculate ranges
        values = pima.map({ $0.DiabetesPedigreeFunction })
        percent = getDataByPercent(percentNet: percentNet, values: values)
        min = filterdiabetesPedigreeFunction - percent
        max = filterdiabetesPedigreeFunction + percent
        // filter table data
        filteredTable = filteredTable.filter{ $0.DiabetesPedigreeFunction <= max }
        filteredTable = filteredTable.filter{ $0.DiabetesPedigreeFunction >= min }
        
        // Age
        // Calculate ranges
        values = pima.map({ $0.Age })
        percent = getDataByPercent(percentNet: percentNet, values: values)
        min = filterAge - percent
        max = filterAge + percent
        // filter table data
        filteredTable = filteredTable.filter{ $0.Age <= max }
        filteredTable = filteredTable.filter{ $0.Age >= min }
    }
    
    func calculateMedian(of values: [Float]) -> Float? {
        guard !values.isEmpty else { return nil }
        
        let sortedValues = values.sorted()
        let count = sortedValues.count
        
        if count % 2 == 0 {
            // If even, return the average of the two middle values
            let middleIndex = count / 2
            return (sortedValues[middleIndex - 1] + sortedValues[middleIndex]) / 2
        } else {
            // If odd, return the middle value
            return sortedValues[count / 2]
        }
    }
    
    func calculateMax(of values: [Float]) -> Float? {
        guard !values.isEmpty else { return nil }
        
        return values.max()
    }
    
    func calculateMin(of values: [Float]) -> Float? {
        guard !values.isEmpty else { return nil }
        
        return values.min()
    }

    var userTable: some View {
        // extract user values for each metric
        let summaryUser =  [
            "Pregnancy": filterPregancies,
            "Glucose": filterGlucose,
            "BP": filterBloodPressure,
            "Skin": filterSkinThickness,
            "Insulin": filterInsulin,
            "BMI": filterBMI,
            "DPF": filterdiabetesPedigreeFunction,
            "Age": filterAge
        ]
        
        let summaryView = List {
            Section(header: Text("Your Values").font(.headline)) {
                ForEach(summaryUser.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack {
                        Text("\(key)")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(value, specifier: "%.1f")")
                    }
                }
            }
        }
        
        return summaryView
    }
    
    
    // create a summary table
    var summaryTable: some View {
        
        // calculate median values for each metric
        let summaryMedian =  [
            "Pregnancy": calculateMedian(of: filteredTable
                .map({ $0.Pregnancies })),
            "Glucose": calculateMedian(of: filteredTable
                .map({ $0.Glucose })),
            "BP": calculateMedian(of: filteredTable
                .map({ $0.BloodPressure })),
            "Skin": calculateMedian(of: filteredTable
                .map({ $0.SkinThickness })),
            "Insulin": calculateMedian(of: filteredTable
                .map({ $0.Insulin })),
            "BMI": calculateMedian(of: filteredTable
                .map({ $0.BMI })),
            "DPF": calculateMedian(of: filteredTable
                .map({ $0.DiabetesPedigreeFunction })),
            "Age": calculateMedian(of: filteredTable
                .map({ $0.Age }))
        ]
        
        // calculate max values for each metric
        let summaryMax =  [
            "Pregnancy": calculateMax(of: filteredTable
                .map({ $0.Pregnancies })),
            "Glucose": calculateMedian(of: filteredTable
                .map({ $0.Glucose })),
            "BP": calculateMax(of: filteredTable
                .map({ $0.BloodPressure })),
            "Skin": calculateMax(of: filteredTable
                .map({ $0.SkinThickness })),
            "Insulin": calculateMax(of: filteredTable
                .map({ $0.Insulin })),
            "BMI": calculateMax(of: filteredTable
                .map({ $0.BMI })),
            "DPF": calculateMax(of: filteredTable
                .map({ $0.DiabetesPedigreeFunction })),
            "Age": calculateMax(of: filteredTable
                .map({ $0.Age }))
        ]
        
        // calculate min values for each metric
        let summaryMin =  [
            "Pregnancy": calculateMin(of: filteredTable
                .map({ $0.Pregnancies })),
            "Glucose": calculateMin(of: filteredTable
                .map({ $0.Glucose })),
            "BP": calculateMin(of: filteredTable
                .map({ $0.BloodPressure })),
            "Skin": calculateMin(of: filteredTable
                .map({ $0.SkinThickness })),
            "Insulin": calculateMin(of: filteredTable
                .map({ $0.Insulin })),
            "BMI": calculateMin(of: filteredTable
                .map({ $0.BMI })),
            "DPF": calculateMin(of: filteredTable
                .map({ $0.DiabetesPedigreeFunction })),
            "Age": calculateMin(of: filteredTable
                .map({ $0.Age }))
        ]
        
        let summaryView = List {
            // show median values
            Section(header: Text("Median").font(.headline)) {
                ForEach(summaryMedian.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack {
                        Text("\(key)")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(value ?? 0, specifier: "%.1f")")
                    }
                }
            }
            // show max values
            Section(header: Text("Max").font(.headline)) {
                ForEach(summaryMax.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack {
                        Text("\(key)")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(value ?? 0, specifier: "%.1f")")
                    }
                }
            }
            // show min values
            Section(header: Text("Min").font(.headline)) {
                ForEach(summaryMin.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack {
                        Text("\(key)")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(value ?? 0, specifier: "%.1f")")
                    }
                }
            }
        }
        .navigationTitle("Stat Summary")
        
        return summaryView
    }
    
    // create a summary table
    var summaryTable0: some View {
        
        // filter filteredTable by outcome = 0
        var outcome0: [Pima] {
            filteredTable.filter { $0.Outcome == 0 }
        }
        
        // calculate median values for each metric
        let summaryMedian =  [
            "Pregnancy": calculateMedian(of: outcome0
                .map({ $0.Pregnancies })),
            "Glucose": calculateMedian(of: outcome0
                .map({ $0.Glucose })),
            "BP": calculateMedian(of: outcome0
                .map({ $0.BloodPressure })),
            "Skin": calculateMedian(of: outcome0
                .map({ $0.SkinThickness })),
            "Insulin": calculateMedian(of: outcome0
                .map({ $0.Insulin })),
            "BMI": calculateMedian(of: outcome0
                .map({ $0.BMI })),
            "DPF": calculateMedian(of: outcome0
                .map({ $0.DiabetesPedigreeFunction })),
            "Age": calculateMedian(of: outcome0
                .map({ $0.Age }))
        ]
        
        // calculate max values for each metric
        let summaryMax =  [
            "Pregnancy": calculateMax(of: outcome0
                .map({ $0.Pregnancies })),
            "Glucose": calculateMedian(of: outcome0
                .map({ $0.Glucose })),
            "BP": calculateMax(of: outcome0
                .map({ $0.BloodPressure })),
            "Skin": calculateMax(of: outcome0
                .map({ $0.SkinThickness })),
            "Insulin": calculateMax(of: outcome0
                .map({ $0.Insulin })),
            "BMI": calculateMax(of: outcome0
                .map({ $0.BMI })),
            "DPF": calculateMax(of: outcome0
                .map({ $0.DiabetesPedigreeFunction })),
            "Age": calculateMax(of: outcome0
                .map({ $0.Age }))
        ]
        
        // calculate min values for each metric
        let summaryMin =  [
            "Pregnancy": calculateMin(of: outcome0
                .map({ $0.Pregnancies })),
            "Glucose": calculateMin(of: outcome0
                .map({ $0.Glucose })),
            "BP": calculateMin(of: outcome0
                .map({ $0.BloodPressure })),
            "Skin": calculateMin(of: outcome0
                .map({ $0.SkinThickness })),
            "Insulin": calculateMin(of: outcome0
                .map({ $0.Insulin })),
            "BMI": calculateMin(of: outcome0
                .map({ $0.BMI })),
            "DPF": calculateMin(of: outcome0
                .map({ $0.DiabetesPedigreeFunction })),
            "Age": calculateMin(of: outcome0
                .map({ $0.Age }))
        ]
        
        let summaryView = List {
            // show median values
            Section(header: Text("Median").font(.headline)) {
                ForEach(summaryMedian.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack {
                        Text("\(key)")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(value ?? 0, specifier: "%.1f")")
                    }
                }
            }
            // show max values
            Section(header: Text("Max").font(.headline)) {
                ForEach(summaryMax.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack {
                        Text("\(key)")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(value ?? 0, specifier: "%.1f")")
                    }
                }
            }
            // show min values
            Section(header: Text("Min").font(.headline)) {
                ForEach(summaryMin.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack {
                        Text("\(key)")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(value ?? 0, specifier: "%.1f")")
                    }
                }
            }
        }
        .navigationTitle("Stat Summary")
        
        return summaryView
    }
    
    // create a summary table
    var summaryTable1: some View {
        // TODO: filter filteredTable by outcome = 1
        var outcome1: [Pima] {
            filteredTable.filter { $0.Outcome == 1 }
        }
        
        // calculate median values for each metric
        let summaryMedian =  [
            "Pregnancy": calculateMedian(of: outcome1
                .map({ $0.Pregnancies })),
            "Glucose": calculateMedian(of: outcome1
                .map({ $0.Glucose })),
            "BP": calculateMedian(of: outcome1
                .map({ $0.BloodPressure })),
            "Skin": calculateMedian(of: outcome1
                .map({ $0.SkinThickness })),
            "Insulin": calculateMedian(of: outcome1
                .map({ $0.Insulin })),
            "BMI": calculateMedian(of: outcome1
                .map({ $0.BMI })),
            "DPF": calculateMedian(of: outcome1
                .map({ $0.DiabetesPedigreeFunction })),
            "Age": calculateMedian(of: outcome1
                .map({ $0.Age }))
        ]
        
        // calculate max values for each metric
        let summaryMax =  [
            "Pregnancy": calculateMax(of: outcome1
                .map({ $0.Pregnancies })),
            "Glucose": calculateMedian(of: outcome1
                .map({ $0.Glucose })),
            "BP": calculateMax(of: outcome1
                .map({ $0.BloodPressure })),
            "Skin": calculateMax(of: outcome1
                .map({ $0.SkinThickness })),
            "Insulin": calculateMax(of: outcome1
                .map({ $0.Insulin })),
            "BMI": calculateMax(of: outcome1
                .map({ $0.BMI })),
            "DPF": calculateMax(of: outcome1
                .map({ $0.DiabetesPedigreeFunction })),
            "Age": calculateMax(of: outcome1
                .map({ $0.Age }))
        ]
        
        // calculate min values for each metric
        let summaryMin =  [
            "Pregnancy": calculateMin(of: outcome1
                .map({ $0.Pregnancies })),
            "Glucose": calculateMin(of: outcome1
                .map({ $0.Glucose })),
            "BP": calculateMin(of: outcome1
                .map({ $0.BloodPressure })),
            "Skin": calculateMin(of: outcome1
                .map({ $0.SkinThickness })),
            "Insulin": calculateMin(of: outcome1
                .map({ $0.Insulin })),
            "BMI": calculateMin(of: outcome1
                .map({ $0.BMI })),
            "DPF": calculateMin(of: outcome1
                .map({ $0.DiabetesPedigreeFunction })),
            "Age": calculateMin(of: outcome1
                .map({ $0.Age }))
        ]
        
        let summaryView = List {
            // show median values
            Section(header: Text("Median").font(.headline)) {
                ForEach(summaryMedian.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack {
                        Text("\(key)")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(value ?? 0, specifier: "%.1f")")
                    }
                }
            }
            // show max values
            Section(header: Text("Max").font(.headline)) {
                ForEach(summaryMax.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack {
                        Text("\(key)")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(value ?? 0, specifier: "%.1f")")
                    }
                }
            }
            // show min values
            Section(header: Text("Min").font(.headline)) {
                ForEach(summaryMin.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack {
                        Text("\(key)")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(value ?? 0, specifier: "%.1f")")
                    }
                }
            }
        }
        .navigationTitle("Stat Summary")
        
        return summaryView
    }
    
    public func loadScatter() -> some View {
        
        let categoryColors: [Int: Color] = [
            0: Color(red: 255 / 255, green: 190 / 255, blue: 247 / 255),
            1: .blue
        ]
        
        let scatterChart = Chart {
            ForEach(filteredTable) { shape in
                PointMark(
                    x: .value("Glucose", shape.id),
                    y: .value("Value", shape.Glucose)
                )
                .foregroundStyle(categoryColors[Int(shape.Outcome)] ?? .black)
            }
        }
        .chartLegend(.hidden)
        .chartYScale(domain: 0...200)
        
        return scatterChart
    }
    
    public func loadBar() -> some View {
        // aggregate counts for bar chart
        let aggregatedData = Dictionary(grouping: filteredTable, by: { $0.Outcome })
            .map { (outcome, items) in
                (category: outcome, count: items.count)
            }
        
        // define custom colors for bar chart legend
        let categoryColors: [Int: Color] = [
            0: .blue,
            1: Color(red: 255 / 255, green: 190 / 255, blue: 247 / 255)
        ]
        
        // create barchart
        let barChart = Chart(aggregatedData, id: \.category) { item in
            BarMark(
                x: .value("Category", item.category),
                y: .value("Count", item.count)
            )
            .annotation(position: .top, alignment: .center) {
                Text("\(item.count)")
                    .font(.caption)
                    .foregroundColor(.black)
            }
            .foregroundStyle(by: .value("Category", item.category))
        }
        .chartXScale(domain: -0.5...1.5)
        .chartForegroundStyleScale(domain: categoryColors.keys.sorted(), range: categoryColors.values.sorted(by: { $0.description < $1.description }))
        
        return barChart
    }
    
    public func loadPie() -> some View {
        let aggregatedData = Dictionary(grouping: filteredTable, by: { $0.Outcome })
            .map { (outcome, items) in
                (category: outcome, count: items.count)
            }
        
        // TODO: trying to draw pie, doesn't seem to identify OS properly
        if #available(iOS 17.0, *) {
            let pieChart = Chart(aggregatedData, id: \.category) { item in
                SectorMark(
                    angle: .value("Count", item.count),
                    innerRadius: .ratio(0.5),
                    angularInset: 0
                )
            }
            return pieChart
        } else {
            // Fallback on earlier versions
            return loadBar()
        }
    }

    public func loadData() {
        if let localData = readLocalFile(forName: "diabetes") {
            parse(jsonData: localData)
            print("File found!")
        } else {
            print("File not found")
        }
    }
    
    // pull in JSON data
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }

    private func parse(jsonData: Data) {
        print("Parsing...")
        do {
            let decodedData = try JSONDecoder().decode([Pima].self,
                                                       from: jsonData)
            print("Pregancies[0]: ", decodedData[0].Pregnancies)
            print("Outcome[0]: ", decodedData[0].Outcome)
            print("===================================")
            // push to shared object
            self.pima = decodedData
        } catch {
            print("decode error")
        }
    }
    
    static var shared = UIJoin()
}
