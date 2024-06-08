public protocol AuthUseCaseProtocol {
    func auth(using user: User, completion: @escaping (Result<Token, DomainError>) -> Void)
}
