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
    
    @Published var filterBMI = Float(75)
    @Published var filterGlucose = Float(200)
    @Published var filterBloodPressure = Float(70)
    @Published var filterSkinThickness = Float(50)
    @Published var filterInsulin = Float(440)
    @Published var filterPregancies = Float(2)
    @Published var filterdiabetesPedigreeFunction = Float(0.50)
    @Published var filterAge = Float(21)
    
    public func loadBMIFilter() {
        filteredBMI = pima.filter{ $0.BMI <= filterBMI }
    }
    
    // TODO: make this filter function for all sliders
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
    
    public func getGlucoseCount() -> Int {
        return filteredGlucose.count
    }
    

    
    public func getFilterGlucoseTable() -> some View  {
        let filteredTable = pima.filter { $0.id < 5 }
        var body: some View {
            Table(filteredTable) {
                // String(format:"%.2f", myFloat)
                TableColumn("Glucose", value: \.GlucoseString)
            }
        }
        // TODO: calculate average Glucose value in filtered data
//        ForEach(filteredGlucose) { shape in
//
//        }
//        pima.Glucose.reduce(0, +)
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
//            .chartYScale(range: 0...200)  // change this to max later
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
