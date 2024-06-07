import Domain
import DomainInterfaces
import XCTest

final class AuthUseCaseSpec: XCTestCase {

    let user: User = .init(cpf: "01464255105", password: "12345678")

    func test_WhenSuccess_ShouldReceiveValidToken() throws {
        let (sut, spy) = try XCTUnwrap(makeTestObjects(isSuccess: true))
        var isSuccess: Bool = false
        var receivedToken: Token?

        sut.auth(using: user) { result in
            switch result {
            case .success(let token):
                isSuccess = true
                receivedToken = token
            case .failure:
                XCTFail("Unexpected result")
            }
        }

        XCTAssertTrue(isSuccess)
        XCTAssertEqual(receivedToken, .init(token: "ValidToken"))
    }

    func test_WhenFailure_ShouldReceiveAnHttpError() throws {
        let (sut, spy) = try XCTUnwrap(makeTestObjects(isSuccess: false))
        var isFailure: Bool = false
        var receivedToken: Token?

        sut.auth(using: user) { result in
            switch result {
            case .success(let token):
                XCTFail("Unexpected result")
            case .failure:
                isFailure = true
            }
        }

        XCTAssertTrue(isFailure)
        XCTAssertNil(receivedToken)
    }

    func makeValidURL() -> URL? {
        URL(string: "https://www.validurl.com")
    }

    func makeTokenData() -> Data? {
        Token(token: "ValidToken").toData()
    }

    func makeTestObjects(isSuccess: Bool) throws -> (sut: AuthUseCase, spy: HttpPostClientSpy) {
        let url = try XCTUnwrap(makeValidURL())
        let spy = HttpPostClientSpy(isSuccess: isSuccess)
        let sut = AuthUseCase(url: url, httpClient: spy)

        return (sut, spy)
    }

}

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

final class HttpPostClientSpy: HttpPostClient {

    private let isSuccess: Bool

    init(isSuccess: Bool = true) {
        self.isSuccess = isSuccess
    }

    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data?, HttpError>) -> Void) {
        if isSuccess {
            let tokenData = Token(token: "ValidToken").toData()
            completion(.success(tokenData))
        } else {
            completion(.failure(.genericError))
        }
    }
}
