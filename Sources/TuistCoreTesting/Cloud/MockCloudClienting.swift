import Foundation
import RxSwift
import TuistSupport

@testable import TuistCore

public enum MockCloudClientingError: Error {
    case mockedError
}

public final class MockCloudClienting<U, E: Error>: CloudClienting {
    
    public init() {}
    
    // MARK: Factories

    public static func makeForSuccess(object: U, response: HTTPURLResponse) -> MockCloudClienting<U, E> {
        let mock = MockCloudClienting<U, E>()
        mock.configureForSuccess(object: object, response: response)
        return mock
    }
    
    public static func makeForError(error: E) -> MockCloudClienting<U, E> {
        let mock = MockCloudClienting<U, E>()
        mock.configureForError(error: error)
        return mock
    }
    
    public static func makeForMultipleCases(
        responsePerURL: [URL: HTTPURLResponse],
        objectPerURL: [URL: U],
        errorPerURL: [URL: E]
    ) -> MockCloudClienting<U, E> {
        let mock = MockCloudClienting<U, E>()
        mock.configureForMultipleCases(
            responsePerURL: responsePerURL,
            objectPerURL: objectPerURL,
            errorPerURL: errorPerURL
        )
        return mock
    }
    
    public var invokedRequest = false
    public var invokedRequestCount = 0
    public var invokedRequestParameter: HTTPResource<U, E>?
    public var invokedRequestParameterList = [HTTPResource<U, E>]()
    
    private var stubbedResponse: HTTPURLResponse?
    private var stubbedObject: U?
    private var stubbedError: Error?
    
    public var stubbedResponsePerURL: [URL: HTTPURLResponse] = [:]
    public var stubbedObjectPerURL: [URL: U] = [:]
    public var stubbedErrorPerURL: [URL: Error] = [:]

    // MARK: Configurations
    
    public func configureForError(error: Error) {
        stubbedError = error
        stubbedObject = nil
        stubbedResponse = nil
    }
    
    public func configureForSuccess(object: U, response: HTTPURLResponse) {
        stubbedError = nil
        stubbedObject = object
        stubbedResponse = response
    }
    
    public func configureForMultipleCases(
        responsePerURL: [URL: HTTPURLResponse],
        objectPerURL: [URL: U],
        errorPerURL: [URL: E]
    ) {
        stubbedError = nil
        stubbedObject = nil
        stubbedResponse = nil
        stubbedResponsePerURL = responsePerURL
        stubbedObjectPerURL = objectPerURL
        stubbedErrorPerURL = errorPerURL
    }
    
    // MARK: Public Interface
    
    public func request<T, Err>(_ resource: HTTPResource<T, Err>) -> Single<(object: T, response: HTTPURLResponse)> {
        invokedRequest = true
        invokedRequestCount += 1
        invokedRequestParameter = resource as? HTTPResource<U, E>
        invokedRequestParameterList.append(invokedRequestParameter!)
        
        // Apply potential stubs for the received URL
        if let url = resource.request().url {
            let errorCandidate = stubbedErrorPerURL[url] ?? stubbedError
            if let error = errorCandidate {
                return Single.error(error)
            } else {
                let objectCandidate = stubbedObjectPerURL[url] ?? stubbedObject
                guard let object = objectCandidate as? T else { fatalError("This function input parameter type should equal to the class one") }
                let responseCandidate = stubbedResponsePerURL[url] ?? stubbedResponse
                return Single.just((object, responseCandidate!))
            }
        } else if let error = stubbedError {
            return Single.error(error)
        } else {
            guard let obj = stubbedObject as? T else { fatalError("This function input parameter type should equal to the class one") }
            return Single.just((obj, stubbedResponse!))
        }
    }
}
