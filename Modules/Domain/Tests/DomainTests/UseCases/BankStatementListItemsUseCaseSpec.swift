import DomainInterfaces
import XCTest

@testable import Domain

final class BankStatementListItemsUseCaseSpec: XCTestCase {

    func test_WhenSuccess_Should() {

    }
}

final class BankStatementListItemsUseCase: BankStatementListItemsUseCaseProtocol {
    private let url: URL
    private let httpClient: HttpPostClient

    init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }

    func getListItems(completion: @escaping (Result<ListItems, DomainError>) -> Void) {
        httpClient.post(to: url, with: nil) { result in
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                break
            }
        }
    }
}

// Helperts

let listItemsJSON = """
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
