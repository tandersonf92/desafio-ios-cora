import DomainInterfaces
import XCTest

@testable import Domain

final class BankStatementListItemsUseCaseSpec: XCTestCase {
    func test_WhenSuccess_ShouldReceiveExpectedListItems() throws {
        let (sut, spy) = try XCTUnwrap(makeTestObjects(isSuccess: true))
        var receivedListItems: ListItems?
        sut.getListItems { result in
            switch result {
            case .success(let listItems):
                receivedListItems = listItems
            case .failure(let failure):
                XCTFail("Unexpected result")
            }
        }

        XCTAssertEqual(spy.receivedURL, URL(string: "https://www.validurl.com"))
        XCTAssertEqual(receivedListItems, expectedListItems)
    }

    func test_WhenFailure_ShouldReceiveGenericError() throws {
        let (sut, spy) = try XCTUnwrap(makeTestObjects(isSuccess: false))
        var receivedError: DomainError?

        sut.getListItems { result in
            switch result {
            case .success(let listItems):
                XCTFail("Unexpected result")
            case .failure(let error):
                receivedError = error
            }
        }

        XCTAssertEqual(spy.receivedURL, URL(string: "https://www.validurl.com"))
        XCTAssertEqual(receivedError, .genericError)
    }

    func makeTestObjects(isSuccess: Bool) throws -> (sut: BankStatementListItemsUseCase, spy: HttpGetClientSpy) {
        let url = try XCTUnwrap(URL(string: "https://www.validurl.com"))
        let spy = HttpGetClientSpy(isSuccess: isSuccess)
        let sut = BankStatementListItemsUseCase(url: url, httpClient: spy)

        return (sut, spy)
    }

    // Helpers
    private let expectedListItems = ListItems(itemsTotal: 1,
                                              results: [.init(items: [.init(id: "abc123def456ghi789",
                                                                            description: "Compra de produtos eletrônicos",
                                                                            label: "Compra aprovada",
                                                                            entry: "DEBIT",
                                                                            amount: 150000,
                                                                            name: "João da Silva",
                                                                            dateEvent: "2024-02-01T08:15:17Z",
                                                                            status: "COMPLETED")],
                                                              date: "2024-02-01")])
}

final class HttpGetClientSpy: HttpGetClient {

    private let isSuccess: Bool

    var receivedURL: URL?

    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    func get(to url: URL, completion: @escaping (Result<Data?, Domain.HttpError>) -> Void) {
        receivedURL = url
        guard isSuccess, let data = listItemsJSON.data(using: .utf8) else { return completion(.failure(.genericError)) }
        completion(.success(data))
    }

    // Helpers
    private let listItemsJSON = """
    {
      "results": [
        {
          "items": [
            {
              "id": "abc123def456ghi789",
              "description": "Compra de produtos eletrônicos",
              "label": "Compra aprovada",
              "entry": "DEBIT",
              "amount": 150000,
              "name": "João da Silva",
              "dateEvent": "2024-02-01T08:15:17Z",
              "status": "COMPLETED"
            }
          ],
          "date": "2024-02-01"
        }
      ],
      "itemsTotal": 1
    }
    """
}

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
                guard let listItems: ListItems = data?.toModel() else { return completion(.failure(.genericError)) }
                completion(.success(listItems))
            case .failure:
                completion(.failure(.genericError))
            }
        }
    }
}
