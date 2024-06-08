import DomainInterfaces
import Foundation

final class BankStatementListItemsUseCase: BankStatementListItemsUseCaseProtocol {
    private let url: URL
    private let httpClient: HttpGetClient

    init(url: URL, httpClient: HttpGetClient) {
        self.url = url
        self.httpClient = httpClient
    }

    func getListItems(completion: @escaping (Result<ListItems, DomainError>) -> Void) {
        httpClient.get(to: url) { result in
            switch result {
            case .success(let data):
                guard let listItems: ListItems = data?.toModel() else { return completion(.failure(.decodeError)) }
                completion(.success(listItems))
            case .failure:
                completion(.failure(.genericError))
            }
        }
    }
}
