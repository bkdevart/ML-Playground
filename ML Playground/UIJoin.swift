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
    
    // TODO: see if you can get this formatted to 2 decimal places
    var BMIString: String { BMI.formatted(.number) }
    var GlucoseString: String { Glucose.formatted(.number) }
}


class UIJoin: ObservableObject {
//    @Published var data = Data()  // is this needed?
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
    
    // TODO: write function that takes feature as parameter and calculates 1%
    public func calcFeaturePercent(percentNet: Float) {
        // Pregancy
        let values = pima.map({ $0.Pregnancies })
        
        
        var min = values.min() ?? 0
        var max = values.max() ?? 0
        let percent = ((max - min) / 100.0) * percentNet
        // figure out new range off of BMIPercent value (add and subtract)
        min = filterBMI - percent
        max = filterBMI + percent
        print("Min: \(min), Max: \(max)")
        
        // BMI
        let bmiValues = pima.map({ $0.BMI })
        var minBMI = bmiValues.min() ?? 0
        var maxBMI = bmiValues.max() ?? 0
        let BMIPercent = ((maxBMI - minBMI) / 100.0) * percentNet
        // figure out new range off of BMIPercent value (add and subtract)
        minBMI = filterBMI - BMIPercent
        maxBMI = filterBMI + BMIPercent
        print("Min: \(minBMI), Max: \(maxBMI)")
        
        
        // filter table data
        filteredTable = pima.filter{ $0.BMI <= maxBMI }
        filteredTable = filteredTable.filter{ $0.BMI >= minBMI }
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
        let barChart = Chart {
            ForEach(filteredTable) { shape in
                PointMark(
                    x: .value("Glucose", shape.id),
                    y: .value("Value", shape.Glucose)
                )
                .foregroundStyle(by: .value("Diabetes", shape.Outcome))
            }
        }
        .chartLegend(.hidden)
        .chartYScale(domain: 0...200)
//            .chartYScale(range: 0...200)  // change this to max later
        return barChart
    }
    
    public func loadBar() -> some View {
        let aggregatedData = Dictionary(grouping: filteredTable, by: { $0.Outcome })
            .map { (outcome, items) in
                (category: outcome, count: items.count)
            }
        let barChart = Chart(aggregatedData, id: \.category) { item in
                    BarMark(
                        x: .value("Category", item.category),
                        y: .value("Count", item.count)
                    )
                }
                .chartXScale(domain: 0...1)
        return barChart
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

    private func parse(jsonData: Data) {  // -> [Pima]
        print("Parsing...")
        do {
            let decodedData = try JSONDecoder().decode([Pima].self,
                                                       from: jsonData)
            print("Pregancies[0]: ", decodedData[0].Pregnancies)
            print("Outcome[0]: ", decodedData[0].Outcome)
            print("===================================")
            // TODO: push to shared object
            self.pima = decodedData
        } catch {
            print("decode error")
        }
    }

    private func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }
            
            urlSession.resume()
        }
    }
    
    static var shared = UIJoin()
}
