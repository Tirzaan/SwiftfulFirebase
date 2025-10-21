//
//  PreformanceView.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 10/20/25.
//

import SwiftUI
import FirebasePerformance

@MainActor
final class PerformanceManager {
    static var shared = PerformanceManager()
    private init() { }
    
    private var traces: [String:Trace] = [:]
    
    func startTrace(name: String) {
        let trace = Performance.startTrace(name: name)
        traces[name] = trace
    }
    
    func setValue(name: String, value: String, forAttribute: String) {
        guard let trace = traces[name] else { return }
        trace.setValue(value, forAttribute: forAttribute)
    }
    
    func stopTrace(name: String) {
        guard let trace = traces[name] else { return }
        trace.stop()
        traces.removeValue(forKey: name)
    }
}

struct PreformanceView: View {
    @State private var title: String = "some title"
    
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                configure()
                downloadProductsAndUploadToFirebase()
                PerformanceManager.shared.startTrace(name: "performance_view_time")
            }
            .onDisappear {
                PerformanceManager.shared.stopTrace(name: "performance_view_time")
            }
    }
    
    private func configure() {
        let traceName = "performance_view_loading"
        let funcStateAttribute = "func_state"
        PerformanceManager.shared.startTrace(name: traceName)
        PerformanceManager.shared.setValue(name: traceName, value: title, forAttribute: "title_text")
        
        Task {
            try? await Task.sleep(for: .seconds(2))
            PerformanceManager.shared.setValue(name: traceName, value: "Started Downloading", forAttribute: funcStateAttribute)
            try? await Task.sleep(for: .seconds(2))
            PerformanceManager.shared.setValue(name: traceName, value: "Continued Downloading", forAttribute: funcStateAttribute)
            try? await Task.sleep(for: .seconds(2))
            PerformanceManager.shared.setValue(name: traceName, value: "Finnishing Downloading", forAttribute: funcStateAttribute)
            try? await Task.sleep(for: .seconds(1))
            PerformanceManager.shared.setValue(name: traceName, value: "Finnished Downloading", forAttribute: funcStateAttribute)

            PerformanceManager.shared.startTrace(name: traceName)
        }
    }
    
        func downloadProductsAndUploadToFirebase() {
            let urlString = "https://dummyjson.com/products"
            guard
                let url = URL(string: urlString),
                let metric = HTTPMetric(url: url, httpMethod: .get) else { return }
            metric.start()
                    
            Task {
                do {
                    let (data, response) = try await URLSession.shared.data(from: url)
                    if let response = response as? HTTPURLResponse {
                        metric.responseCode = response.statusCode
                    }
                    metric.stop()
                    print("SUCCESS")
                } catch {
                    print(error)
                    metric.stop()
                }
            }
        }
//    guard let metric = HTTPMetric(url: "https://www.google.com", httpMethod: .get) else { return }
//
//    metric.start()
//    guard let url = URL(string: "https://www.google.com") else { return }
//    let request: URLRequest = URLRequest(url:url)
//    let session = URLSession(configuration: .default)
//    let dataTask = session.dataTask(with: request) { (urlData, response, error) in
//            if let httpResponse = response as? HTTPURLResponse {
//             metric.responseCode = httpResponse.statusCode
//            }
//            metric.stop()
//    }
//    dataTask.resume()
}

#Preview {
    PreformanceView()
}
