//___FILEHEADER___

import XCTest

final class ___VARIABLE_productName:identifier___ManagerTests: TestCase {}

extension ___VARIABLE_productName:identifier___ManagerTests {
    
    func testFetch() {
        // Given
        var promise = expectation(description: #function)
        
        let request = FetchRequest()
        var response: [___VARIABLE_productName:identifier___]?
        
        // When
        ___VARIABLE_productName:identifier___Manager.fetch(with: request) {
            defer { promise?.fulfill() }
            
            guard case let .success(value) = $0 else {
                XCTFail("The request failed: \(String(describing: $0.error))")
                return
            }
            
            response = value
        }
        
        wait(for: [promise], timeout: 10)
            
        // Then
        XCTAssertNotNil(response)
        XCTAssertFalse(response.isEmpty)
    }
}
