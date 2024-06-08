import DomainInterfaces
import Foundation

final class BankStatementItemDetailsUseCase: BankStatementItemDetailsUseCaseProtocol {

    private let baseUrl: URL
    private let httpClient: HttpGetClient

    init(baseUrl: URL, httpClient: HttpGetClient) {
        self.baseUrl = baseUrl
        self.httpClient = httpClient
    }

    func getItemDetails(of id: String, completion: @escaping (Result<DomainInterfaces.ItemDetails, DomainInterfaces.DomainError>) -> Void) {
        guard let url = URL(string: "\(baseUrl.absoluteString)/\(id)") else { return completion(.failure(.genericError)) } // TODO: criar novo erro
        httpClient.get(to: url) { result in
            switch result {
            case .success(let data):
                guard let itemDetails: ItemDetails = data?.toModel() else { return completion(.failure(.decodeError)) }
                completion(.success(itemDetails))
            case .failure:
                completion(.failure(.genericError))
            }
        }
    }
}
