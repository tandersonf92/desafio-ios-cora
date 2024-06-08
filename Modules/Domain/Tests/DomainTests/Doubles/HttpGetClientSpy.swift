import Domain
import Foundation

final class HttpGetClientSpy: HttpGetClient {

    private let isSuccess: Bool
    var jsonString: String

    var receivedURL: URL?

    init(isSuccess: Bool, jsonString: String = "") {
        self.isSuccess = isSuccess
        self.jsonString = jsonString
    }
    func get(to url: URL, completion: @escaping (Result<Data?, Domain.HttpError>) -> Void) {
        receivedURL = url
        guard isSuccess, let data = jsonString.data(using: .utf8) else { return completion(.failure(.genericError)) }
        completion(.success(data))
    }
}
