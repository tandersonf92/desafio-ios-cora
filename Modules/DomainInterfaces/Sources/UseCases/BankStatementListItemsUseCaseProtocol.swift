public protocol BankStatementListItemsUseCaseProtocol {
    func getListItems(completion: @escaping (Result<ListItems, DomainError>) -> Void)
}
