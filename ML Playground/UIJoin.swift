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
}

class UIJoin: ObservableObject {
    @Published var data = Data()
    @Published var pima = [Pima]()
    


    
    public func loadBMI() -> some View {
        
    
                           
        Chart {
            ForEach(pima) { shape in
                PointMark(
                    x: .value("BMI", shape.id),
                    y: .value("Value", shape.BMI)
                )
                .foregroundStyle(by: .value("Diabetes", shape.Outcome))
            }
        }
    }
    
    public func loadGlucose() -> some View {
        let barChart = Chart {
            ForEach(pima) { shape in
                PointMark(
                    x: .value("Glucose", shape.id),
                    y: .value("Value", shape.Glucose)
                )
                .foregroundStyle(by: .value("Diabetes", shape.Outcome))
            }
        }
        
        return barChart
    }
    
    public func loadData() {
        if let localData = readLocalFile(forName: "diabetes") {
            parse(jsonData: localData)

            print("File found!")
//            data = localData
            // TODO: do I need to do additional assignments here?
            
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
