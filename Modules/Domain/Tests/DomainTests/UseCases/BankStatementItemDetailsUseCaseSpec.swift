import DomainInterfaces
import XCTest

@testable import Domain

final class BankStatementItemDetailsUseCaseSpec: XCTestCase {

    func test_WhenSuccess_ShouldReceiveExpectedItemDetails() throws {
        let (sut, spy) = try makeTestObjects(isSuccess: true)
        var receivedItemDetails: ItemDetails?
        sut.getItemDetails(of: "abcdef12-3456-7890-abcd-ef1234567890") { result in
            switch result {
            case .success(let itemDetails):
                receivedItemDetails = itemDetails
            case .failure(_):
                XCTFail("Unexpected result")
            }
        }

        XCTAssertEqual(spy.receivedURL?.absoluteString, "https://api.challenge.stage.cora.com.br/challenge/details/abcdef12-3456-7890-abcd-ef1234567890")
        XCTAssertEqual(receivedItemDetails, expectedItemDetails)
    }

    func test_WhenFialure_ShouldReceiveGenericError() throws {
        let (sut, spy) = try makeTestObjects(isSuccess: false)
        var receivedError: DomainError?
        var isFailure: Bool = false
        sut.getItemDetails(of: "abcdef12-3456-7890-abcd-ef1234567890") { result in
            switch result {
            case .success(_):
                XCTFail("Unexpected result")
            case .failure(let error):
                isFailure = true
                receivedError = error
            }
        }

        XCTAssertEqual(spy.receivedURL?.absoluteString, "https://api.challenge.stage.cora.com.br/challenge/details/abcdef12-3456-7890-abcd-ef1234567890")
        XCTAssertEqual(receivedError, .genericError)
        XCTAssertTrue(isFailure)
    }

    func makeTestObjects(isSuccess: Bool) throws -> (sut: BankStatementItemDetailsUseCase, spy: HttpGetClientSpy) {
        let url = try XCTUnwrap(URL(string: "https://api.challenge.stage.cora.com.br/challenge/details"))
        let spy = HttpGetClientSpy(isSuccess: isSuccess, jsonString: JSONStrings.getItemDetailsJSON())
        let sut = BankStatementItemDetailsUseCase(baseUrl: url, httpClient: spy)

        return (sut, spy)
    }

    let expectedItemDetails: ItemDetails = ItemDetails(description: "Pagamento por serviços prestados",
                                                       label: "Pagamento recebido",
                                                       amount: 150000,
                                                       counterPartyName: "Empresa ABC LTDA",
                                                       dateEvent: "2024-02-05T14:30:45Z",
                                                       status: "COMPLETED",
                                                       recipient: .init(bankName: "Banco XYZ",
                                                                        bankNumber: "001",
                                                                        documentNumber: "11223344000155",
                                                                        documentType: "CNPJ",
                                                                        accountNumberDigit: "9",
                                                                        agencyNumberDigit: "7",
                                                                        agencyNumber: "1234",
                                                                        name: "Empresa ABC LTDA",
                                                                        accountNumber: "987654"),
                                                       sender: .init(bankName: "Banco ABC",
                                                                     bankNumber: "002",
                                                                     documentNumber: "99887766000112",
                                                                     documentType: "CNPJ",
                                                                     accountNumberDigit: "3",
                                                                     agencyNumberDigit: "1",
                                                                     agencyNumber: "5678",
                                                                     name: "Empresa XYZ LTDA",
                                                                     accountNumber: "543210"))
}
