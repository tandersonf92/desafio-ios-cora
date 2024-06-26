public struct ListItems: Decodable, Equatable {
    public struct Items: Decodable, Equatable {
        public let items: [Item]
        public let date: String

        public init(items: [Item], date: String) {
            self.items = items
            self.date = date
        }
    }

    public struct Item: Decodable, Equatable {
        public let id: String
        public let description: String
        public let label: String
        public let entry: String
        public let amount: Int
        public let name: String
        public let dateEvent: String
        public let status: String

        public init(id: String, description: String, label: String, entry: String, amount: Int, name: String, dateEvent: String, status: String) {
            self.id = id
            self.description = description
            self.label = label
            self.entry = entry
            self.amount = amount
            self.name = name
            self.dateEvent = dateEvent
            self.status = status
        }
    }

    public let itemsTotal: Int
    public let results: [Items]

    public init(itemsTotal: Int, results: [Items]) {
        self.itemsTotal = itemsTotal
        self.results = results
    }
}
