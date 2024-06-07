public protocol BankStatementItemDetailsUseCaseProtocol {
    func getItemDetails(of id: String, completion: @escaping (Result<ListItems, DomainError>) -> Void)
}
