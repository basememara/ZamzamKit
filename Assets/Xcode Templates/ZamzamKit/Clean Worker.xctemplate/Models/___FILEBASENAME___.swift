//___FILEHEADER___

public struct ___VARIABLE_productName:identifier___: ___VARIABLE_productName:identifier___Type, Decodable {
    public let id: Int
}

// MARK: - For JSON decoding

extension ___VARIABLE_productName:identifier___ {
    
    private enum CodingKeys: String, CodingKey {
        case id = "object_id"
    }
}