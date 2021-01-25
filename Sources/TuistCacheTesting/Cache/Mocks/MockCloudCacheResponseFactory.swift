import Foundation
import TuistCache

class MockCloudCacheResponseFactory : CloudCacheResponseManufacturing {
    
    public init() {}
    
    public var invokedFetchResource = false
    public var invokedFetchResourceCount = 0
    public var invokedFetchResourceParameters: (hash: String, cloud: Cloud)?
    public var invokedFetchResourceParametersList = [(hash: String, cloud: Cloud)]()
    public var stubbedFetchResourceError: Error?
    public var stubbedFetchResourceResult: CloudCacheResource!

    public func fetchResource(hash: String, cloud: Cloud) throws -> CloudCacheResource {
        invokedFetchResource = true
        invokedFetchResourceCount += 1
        invokedFetchResourceParameters = (hash, cloud)
        invokedFetchResourceParametersList.append((hash, cloud))
        if let error = stubbedFetchResourceError {
            throw error
        }
        return stubbedFetchResourceResult
    }

    public var invokedStoreResource = false
    public var invokedStoreResourceCount = 0
    public var invokedStoreResourceParameters: (hash: String, cloud: Cloud, contentMD5: String)?
    public var invokedStoreResourceParametersList = [(hash: String, cloud: Cloud, contentMD5: String)]()
    public var stubbedStoreResourceError: Error?
    public var stubbedStoreResourceResult: CloudCacheResource!

    public func storeResource(hash: String, cloud: Cloud, contentMD5: String) throws -> CloudCacheResource {
        invokedStoreResource = true
        invokedStoreResourceCount += 1
        invokedStoreResourceParameters = (hash, cloud, contentMD5)
        invokedStoreResourceParametersList.append((hash, cloud, contentMD5))
        if let error = stubbedStoreResourceError {
            throw error
        }
        return stubbedStoreResourceResult
    }

    public var invokedVerifyUploadResource = false
    public var invokedVerifyUploadResourceCount = 0
    public var invokedVerifyUploadResourceParameters: (hash: String, cloud: Cloud, contentMD5: String)?
    public var invokedVerifyUploadResourceParametersList = [(hash: String, cloud: Cloud, contentMD5: String)]()
    public var stubbedVerifyUploadResourceError: Error?
    public var stubbedVerifyUploadResourceResult: CloudCacheResource!

    public func verifyUploadResource(hash: String, cloud: Cloud, contentMD5: String) throws -> CloudCacheResource {
        invokedVerifyUploadResource = true
        invokedVerifyUploadResourceCount += 1
        invokedVerifyUploadResourceParameters = (hash, cloud, contentMD5)
        invokedVerifyUploadResourceParametersList.append((hash, cloud, contentMD5))
        if let error = stubbedVerifyUploadResourceError {
            throw error
        }
        return stubbedVerifyUploadResourceResult
    }
}
