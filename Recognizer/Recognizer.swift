import CoreML
import Vision

public protocol RecognizerDelegate: class {
    func recognizer(_ recognizer: Recognizer, didFinishRequestWith identifiers: [String])
}

public class Recognizer {

    public weak var delegate: RecognizerDelegate?

    let modelFile: MLModel

    public init(modelFile: MLModel) {
        self.modelFile = modelFile
    }

    // default is take all results
    public func performRequest(with url: URL, resultsCount: Int = -1)
    {
        guard let model = try? VNCoreMLModel(for: modelFile) else { return }

        let handler = VNImageRequestHandler(url: url)
        let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, _ in
            self?.requestCompletionHandler(request: request,
                                           resultsCount: resultsCount)
        })
        try? handler.perform([request])
    }

    func requestCompletionHandler(request: VNRequest, resultsCount: Int) {
        guard let observation = request.results as? [VNClassificationObservation] else { return }
        let observationsSortedByConfidence = observation.sorted(by: { $0.confidence > $1.confidence })
        var identifiers = observationsSortedByConfidence.map { $0.identifier }
        if resultsCount >= 0 {
            identifiers = Array(identifiers[..<resultsCount])
        }
        delegate?.recognizer(self, didFinishRequestWith: identifiers)
    }

}
