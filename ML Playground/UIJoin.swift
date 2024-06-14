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
    @Published var filteredBMI = [Pima]()
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
    
    public func loadBMIFilter() {
        filteredBMI = pima.filter{ $0.BMI <= filterBMI }
    }
    
    public func loadFilters() {
        filteredTable = pima.filter{ $0.Pregnancies <= filterPregancies }
        filteredTable = filteredTable.filter{ $0.Glucose <= filterGlucose }
        filteredTable = filteredTable.filter{ $0.BloodPressure <= filterBloodPressure }
        filteredTable = filteredTable.filter{ $0.SkinThickness <= filterSkinThickness }
        filteredTable = filteredTable.filter{ $0.Insulin <= filterInsulin }
        filteredTable = filteredTable.filter{ $0.BMI <= filterBMI }
        filteredTable = filteredTable.filter{ $0.DiabetesPedigreeFunction <= filterdiabetesPedigreeFunction }
        filteredTable = filteredTable.filter{ $0.Age <= filterAge }
    }
    
    public func getFilterBMITable() -> some View  {
        let filteredTable = pima.filter { $0.id < 5 }
        var body: some View {
            Table(filteredTable) {
                // String(format:"%.2f", myFloat)
                TableColumn("BMI", value: \.BMIString)
                // 2nd column not visible in iOS, unless you tweak
                // https://developer.apple.com/documentation/SwiftUI/Table
                // TableColumn("Glucose", value: \.GlucoseString)
            }
        }
        return body
    }
    
    public func getBMIMean() -> String {
        let totalSum = filteredBMI.map({$0.BMI}).reduce(0, +)
        let totalCount = filteredBMI.count
        let mean = String(format: "%.2f", totalSum / Float(totalCount))
        return mean
    }
    
    public func getBMICount() -> Int {
        return filteredBMI.count
    }
    
    public func getGlucoseMean() -> String {
        let totalSum = filteredGlucose.map({$0.Glucose}).reduce(0, +)
        let totalCount = filteredGlucose.count
        let mean = String(format: "%.2f", totalSum / Float(totalCount))
        return mean
    }
    
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
    
    // TODO: write function that takes feature as parameter and calculates 1%
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
        
//        print("Min: \(min), Max: \(max)")
        
        
    }
    
    public func getFilterGlucoseTable() -> some View  {
        let filteredTable = pima.filter { $0.id < 5 }
        var body: some View {
            Table(filteredTable) {
                // String(format:"%.2f", myFloat)
                TableColumn("Glucose", value: \.GlucoseString)
            }
        }
        return body
    }
    
    public func showBMI() -> some View {
        Chart {
            ForEach(filteredBMI) { shape in
                PointMark(
                    x: .value("BMI", shape.id),
                    y: .value("Value", shape.BMI)
                )
                .foregroundStyle(by: .value("Diabetes", shape.Outcome))
            }
        }
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

//    private func loadJson(fromURLString urlString: String,
//                          completion: @escaping (Result<Data, Error>) -> Void) {
//        if let url = URL(string: urlString) {
//            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
//                if let error = error {
//                    completion(.failure(error))
//                }
//                
//                if let data = data {
//                    completion(.success(data))
//                }
//            }
//            
//            urlSession.resume()
//        }
//    }
    
    static var shared = UIJoin()
}
