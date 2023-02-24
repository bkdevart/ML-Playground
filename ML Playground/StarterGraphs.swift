//
//  StarterGraphs.swift
//  ML Slide
//
//  Created by Brandon Knox on 2/21/23.
//

import SwiftUI
import Charts
import UniformTypeIdentifiers


// TODO: make this view tabular so you can view different graphs

// https://developer.apple.com/documentation/charts/creating-a-chart-using-swift-charts
// TODO: create struct to mimic csv file

struct ToyShape: Identifiable {
    var type: String
    var count: Double
    var id = UUID()
}

struct Pima: Codable {
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

var data: [ToyShape] = [
    .init(type: "Cube", count: 5),
    .init(type: "Sphere", count: 4),
    .init(type: "Pyramid", count: 4)
]

struct BarChart: View {
    var body: some View {
        Chart {
            // TODO: modify these marks to show features of data (maybe feature importances?)
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

//struct GlucoseChart: View {
//    var body: some View {
//        Chart {
//            BarMark(
//                x: .value("Shape Type", decodedData[0].Glucose),
//                y: .value("Total Count", decodedData[0].BMI)
//            )
//            BarMark(
//                 x: .value("Shape Type", decodedData[1].Glucose),
//                 y: .value("Total Count", decodedData[1].BMI)
//            )
//            BarMark(
//                 x: .value("Shape Type", decodedData[2].Glucose),
//                 y: .value("Total Count", decodedData[2].BMI)
//            )
//        }
//    }
//}


struct StarterGraphs: View {
    
    // TODO: get this working so you have data to share between views
    private var decodedData = [Pima]()
    

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
//            return decodedData
        } catch {
            print("decode error")
//            return [Pima]()
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
    
    var body: some View {
        TabView {
            BarChart()
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Bar")
                }
            
            Text("Other Chart")
//            GlucoseChart()
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "chart.dots.scatter")
                    Text("Other")
                }
        }
        .onAppear {
            if let localData = self.readLocalFile(forName: "diabetes") {
                self.parse(jsonData: localData)
                // TODO: do I need to do additional assignments here?
                print("File found!")
            } else {
                print("File not found")
            }
        }
    }
        
}

struct StarterGraphs_Previews: PreviewProvider {
    static var previews: some View {
        StarterGraphs()
    }
}
