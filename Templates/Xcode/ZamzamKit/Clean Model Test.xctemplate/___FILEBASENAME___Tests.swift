//___FILEHEADER___

import XCTest

final class ___VARIABLE_productName:identifier___ModelTests: XCTestCase {
    
    func testDecoding() throws {
        let model = try JSONDecoder.default.decode(___VARIABLE_productName:identifier___.self, fromJSON: #file)
        
        XCTAssertEqual(model.id, 1)
    }
}
