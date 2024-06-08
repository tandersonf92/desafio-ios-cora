public struct User: Model {
    let cpf: String
    let password: String

    public init(cpf: String, password: String) {
        self.cpf = cpf
        self.password = password
    }
}
