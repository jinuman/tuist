import TuistCloud
import TuistCore
import TuistGraph
import TuistSupport
@testable import TuistCache

public class MockCloudCacheResourceFactory: CloudCacheResourceManufacturing {
    var invokedExistsResource = false
    var invokedExistsResourceCount = 0
    var invokedExistsResourceParameters: (hash: String, Void)?
    var invokedExistsResourceParametersList = [(hash: String, Void)]()
    var stubbedExistsResourceError: Error?
    var stubbedExistsResourceResult: HTTPResource<CloudResponse<CloudHEADResponse>, CloudHEADResponseError>!

    public func existsResource(hash: String) throws -> HTTPResource<CloudResponse<CloudHEADResponse>, CloudHEADResponseError> {
        invokedExistsResource = true
        invokedExistsResourceCount += 1
        invokedExistsResourceParameters = (hash, ())
        invokedExistsResourceParametersList.append((hash, ()))
        if let error = stubbedExistsResourceError {
            throw error
        }
        return stubbedExistsResourceResult
    }

    var invokedFetchResource = false
    var invokedFetchResourceCount = 0
    var invokedFetchResourceParameters: (hash: String, Void)?
    var invokedFetchResourceParametersList = [(hash: String, Void)]()
    var stubbedFetchResourceError: Error?
    var stubbedFetchResourceResult: CloudCacheResource!

    public func fetchResource(hash: String) throws -> CloudCacheResource {
        invokedFetchResource = true
        invokedFetchResourceCount += 1
        invokedFetchResourceParameters = (hash, ())
        invokedFetchResourceParametersList.append((hash, ()))
        if let error = stubbedFetchResourceError {
            throw error
        }
        return stubbedFetchResourceResult
    }

    var invokedStoreResource = false
    var invokedStoreResourceCount = 0
    var invokedStoreResourceParameters: (hash: String, contentMD5: String)?
    var invokedStoreResourceParametersList = [(hash: String, contentMD5: String)]()
    var stubbedStoreResourceError: Error?
    var stubbedStoreResourceResult: CloudCacheResource!

    public func storeResource(hash: String, contentMD5: String) throws -> CloudCacheResource {
        invokedStoreResource = true
        invokedStoreResourceCount += 1
        invokedStoreResourceParameters = (hash, contentMD5)
        invokedStoreResourceParametersList.append((hash, contentMD5))
        if let error = stubbedStoreResourceError {
            throw error
        }
        return stubbedStoreResourceResult
    }

    var invokedVerifyUploadResource = false
    var invokedVerifyUploadResourceCount = 0
    var invokedVerifyUploadResourceParameters: (hash: String, contentMD5: String)?
    var invokedVerifyUploadResourceParametersList = [(hash: String, contentMD5: String)]()
    var stubbedVerifyUploadResourceError: Error?
    var stubbedVerifyUploadResourceResult: CloudCacheResource!

    public func verifyUploadResource(hash: String, contentMD5: String) throws -> CloudCacheResource {
        invokedVerifyUploadResource = true
        invokedVerifyUploadResourceCount += 1
        invokedVerifyUploadResourceParameters = (hash, contentMD5)
        invokedVerifyUploadResourceParametersList.append((hash, contentMD5))
        if let error = stubbedVerifyUploadResourceError {
            throw error
        }
        return stubbedVerifyUploadResourceResult
    }
}
