//___FILEHEADER___

import XCTest
@testable import ZamzamKit

final class ___VARIABLE_productName:identifier___ModelTests: XCTestCase {
    
    func testDecoding() {
        do {
            let model = try JSONDecoder.default.decode(
                ___VARIABLE_productName:identifier___.self,
                forResource: "___VARIABLE_productName:identifier___.json",
                inBundle: .test
            )
            
            XCTAssertEqual(model.id, 1)
        } catch {
            XCTFail("Could not parse JSON: \(error)")
        }
    }
}
