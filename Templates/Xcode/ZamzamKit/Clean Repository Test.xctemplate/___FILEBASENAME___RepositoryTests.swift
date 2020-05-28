//___FILEHEADER___

import XCTest

final class ___VARIABLE_productName:identifier___RepositoryTests: TestCase {}

extension ___VARIABLE_productName:identifier___RepositoryTests {
    
    func testFetch() {
        // Given
        var promise = expectation(description: #function)
        
        let request = FetchRequest()
        var response: [___VARIABLE_productName:identifier___]?
        
        // When
        ___VARIABLE_productName:identifier___Repository.fetch(with: request) {
            defer { promise?.fulfill() }
            
            guard case .success(let value) = $0 else {
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
