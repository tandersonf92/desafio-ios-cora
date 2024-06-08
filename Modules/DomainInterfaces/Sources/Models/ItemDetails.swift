public struct ItemDetails: Decodable, Equatable {
    public let description: String
    public let label: String
    public let amount: Int
    public let counterPartyName: String
    public let dateEvent: String
    public let status: String
    public let recipient: Account
    public let sender: Account

    public init(description: String, label: String, amount: Int, counterPartyName: String, dateEvent: String, status: String, recipient: Account, sender: Account) {
        self.description = description
        self.label = label
        self.amount = amount
        self.counterPartyName = counterPartyName
        self.dateEvent = dateEvent
        self.status = status
        self.recipient = recipient
        self.sender = sender
    }

    public struct Account: Decodable, Equatable {
        public let bankName: String
        public let bankNumber: String
        public let documentNumber: String
        public let documentType: String
        public let accountNumberDigit: String
        public let agencyNumberDigit: String
        public let agencyNumber: String
        public let name: String
        public let accountNumber: String

        public init(bankName: String, bankNumber: String, documentNumber: String, documentType: String, accountNumberDigit: String, agencyNumberDigit: String, agencyNumber: String, name: String, accountNumber: String) {
            self.bankName = bankName
            self.bankNumber = bankNumber
            self.documentNumber = documentNumber
            self.documentType = documentType
            self.accountNumberDigit = accountNumberDigit
            self.agencyNumberDigit = agencyNumberDigit
            self.agencyNumber = agencyNumber
            self.name = name
            self.accountNumber = accountNumber
        }
    }
}
