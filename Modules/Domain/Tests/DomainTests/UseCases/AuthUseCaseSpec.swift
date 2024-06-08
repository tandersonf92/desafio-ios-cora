import DomainInterfaces
import XCTest

@testable import Domain

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
        XCTAssertEqual(spy.receivedURL, URL(string: "https://www.validurl.com"))
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
        XCTAssertEqual(spy.receivedURL, URL(string: "https://www.validurl.com"))
    }

    func makeTestObjects(isSuccess: Bool) throws -> (sut: AuthUseCase, spy: HttpPostClientSpy) {
        let url = try XCTUnwrap(URL(string: "https://www.validurl.com"))
        let spy = HttpPostClientSpy(isSuccess: isSuccess)
        let sut = AuthUseCase(url: url, httpClient: spy)

        return (sut, spy)
    }
}

final class HttpPostClientSpy: HttpPostClient {

    var receivedURL: URL?
    private let isSuccess: Bool

    init(isSuccess: Bool = true) {
        self.isSuccess = isSuccess
    }

    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data?, HttpError>) -> Void) {
        receivedURL = url
        if isSuccess {
            let tokenData = Token(token: "ValidToken").toData()
            completion(.success(tokenData))
        } else {
            completion(.failure(.genericError))
        }
    }
}
