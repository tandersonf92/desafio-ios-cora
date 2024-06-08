enum JSONStrings {
    static func getListItemsJSON() -> String {
            """
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

    static func getItemDetailsJSON() -> String {
        """
    {
      "description": "Pagamento por serviços prestados",
      "label": "Pagamento recebido",
      "amount": 150000,
      "counterPartyName": "Empresa ABC LTDA",
      "id": "abcdef12-3456-7890-abcd-ef1234567890",
      "dateEvent": "2024-02-05T14:30:45Z",
      "recipient": {
        "bankName": "Banco XYZ",
        "bankNumber": "001",
        "documentNumber": "11223344000155",
        "documentType": "CNPJ",
        "accountNumberDigit": "9",
        "agencyNumberDigit": "7",
        "agencyNumber": "1234",
        "name": "Empresa ABC LTDA",
        "accountNumber": "987654"
      },
      "sender": {
        "bankName": "Banco ABC",
        "bankNumber": "002",
        "documentNumber": "99887766000112",
        "documentType": "CNPJ",
        "accountNumberDigit": "3",
        "agencyNumberDigit": "1",
        "agencyNumber": "5678",
        "name": "Empresa XYZ LTDA",
        "accountNumber": "543210"
      },
      "status": "COMPLETED"
    }
    """
    }
}
