import DomainInterfaces
import Foundation

final class AuthUseCase: AuthUseCaseProtocol {
    private let url: URL
    private let httpClient: HttpPostClient

    init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }

    func auth(using user: User, completion: @escaping (Result<DomainInterfaces.Token, DomainError>) -> Void) {
        httpClient.post(to: url, with: user.toData()) { result in
            switch result {
            case .success(let data):
                guard let token: Token = data?.toModel() else { return completion(.failure(.genericError)) }
                    completion(.success(token))
            case .failure:
                completion(.failure(.genericError))
            }
        }
    }
}
