import SwiftUI
import Vision
internal import UniformTypeIdentifiers

struct ContentView: View {
  
  @State private var droppedFiles: [URL] = []
  @State private var isTarget = false
  @State private var fileContent = ""
  
  var body: some View {
    VStack {
      Text(isTarget ? "Drop it!": "Drag your photos here")
        .font(.headline)
      
      ForEach(droppedFiles, id: \.self) { url in
        Text(url.lastPathComponent).font(.caption)
      }
      
      TextEditor(text: $fileContent).font(Font.custom("Geist Mono", size: 18))
        .lineHeight(.loose)
        .padding(2)
        .overlay(
        RoundedRectangle(cornerRadius: 8)
          .stroke(Color.gray.opacity(0.5), lineWidth: 1)
      )
      .textFieldStyle(.roundedBorder)
      .lineLimit(8...14) // Optional: Sets a min of 5 lines and max of 10
      
      
    }.frame(width: 700, height: 500)
      .padding()
      .onDrop(of: [.image], isTargeted: $isTarget, perform: { providers in
        guard let provider = providers.first else { return false }
  
        _ = provider.loadDataRepresentation(for: .image) { data, error in
          if error == nil, let data {
            
            DispatchQueue.main.async {
              let ex = TextExtractor()
              self.fileContent = "Loading..."
              ex.extractText(from: data) { text in
                DispatchQueue.main.async {
                  fileContent = text
                }
              }
            }
            
            
            
          }
        }
        return true
      })
  }
  
}

#Preview {
  ContentView()
}
