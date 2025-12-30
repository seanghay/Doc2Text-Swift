import SwiftUI
import Vision

class TextExtractor {
  func extractText(from data: Data, completion: @escaping (String) -> Void) {
    let request = VNRecognizeTextRequest { (request, error) in
      
      guard let observations = request.results as? [VNRecognizedTextObservation] else {
        completion("No text found.")
        return
      }
      
      let recognizedStrings = observations.compactMap { observation in
        let str = observation.topCandidates(1).first?.string
        return "{text: \(str!), confidence: \(observation.confidence)}"
      }
    
      completion(recognizedStrings.joined(separator: "\n"))
    }
    
    request.automaticallyDetectsLanguage = true // <-- This is the issue.
    request.recognitionLevel = .accurate
    
    let handler = VNImageRequestHandler(data: data, options: [:])
    
    DispatchQueue.global(qos: .background).async {
      do {
        try handler.perform([request])
      } catch {
        completion("Failed to perform OCR: \(error.localizedDescription)")
      }
    }
  }
}
