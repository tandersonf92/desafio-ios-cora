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
            case .failure(_):
                XCTFail("Unexpected result")
            }
        }

        XCTAssertEqual(spy.receivedURL, URL(string: "https://www.validurl.com"))
        XCTAssertEqual(receivedListItems, expectedListItems)
    }

    func test_WhenFailure_ShouldReceiveGenericError() throws {
        let (sut, spy) = try XCTUnwrap(makeTestObjects(isSuccess: false))
        var receivedError: DomainError?
        var isFailure: Bool = false

        sut.getListItems { result in
            switch result {
            case .success(_):
                XCTFail("Unexpected result")
            case .failure(let error):
                receivedError = error
                isFailure = true
            }
        }

        XCTAssertEqual(spy.receivedURL, URL(string: "https://www.validurl.com"))
        XCTAssertEqual(receivedError, .genericError)
        XCTAssertTrue(isFailure)
    }

    func makeTestObjects(isSuccess: Bool) throws -> (sut: BankStatementListItemsUseCase, spy: HttpGetClientSpy) {
        let url = try XCTUnwrap(URL(string: "https://www.validurl.com"))
        let jsonString = JSONStrings.getListItemsJSON()
        let spy = HttpGetClientSpy(isSuccess: isSuccess, jsonString: jsonString)
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
