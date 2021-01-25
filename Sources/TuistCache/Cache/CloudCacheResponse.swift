import Foundation
import TuistCore
import TuistGraph
import TuistSupport

protocol CloudCacheResponseManufacturing {
    func fetchResource(hash: String) throws -> CloudCacheResource
    func storeResource(hash: String, contentMD5: String) throws -> CloudCacheResource
    func verifyUploadResource(hash: String, contentMD5: String) throws -> CloudCacheResource
}

class CloudCacheResponseFactory: CloudCacheResponseManufacturing {
    
    private let cloudConfig: Cloud
    
    init(cloudConfig: Cloud) {
        self.cloudConfig = cloudConfig
    }
    
    public func fetchResource(hash: String) throws -> CloudCacheResource {
        let url = try URL.apiCacheURL(
            hash: hash,
            cacheURL: cloudConfig.url,
            projectId: cloudConfig.projectId
        )
        return jsonResource(for: url, httpMethod: "GET")
    }

    public func storeResource(hash: String, contentMD5: String) throws -> CloudCacheResource
    {
        let url = try URL.apiCacheURL(
            hash: hash,
            cacheURL: cloudConfig.url,
            projectId: cloudConfig.projectId,
            contentMD5: contentMD5
        )
        return jsonResource(for: url, httpMethod: "POST")
    }

    public func verifyUploadResource(hash: String, cloud: Cloud, contentMD5: String) throws -> CloudCacheResource
    {
        let url = try URL.apiCacheVerifyUploadURL(
            hash: hash,
            cacheURL: cloudConfig.url,
            projectId: cloudConfig.projectId,
            contentMD5: contentMD5
        )
        return jsonResource(for: url, httpMethod: "POST")
    }

    private func jsonResource(for url: URL, httpMethod: String) -> CloudCacheResource {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return .jsonResource { request }
    }
}

struct CloudCacheResponse: Decodable {
    typealias CloudCacheResource = HTTPResource<CloudResponse<CloudCacheResponse>, CloudResponseError>

    let url: URL
    let expiresAt: TimeInterval

    init(url: URL, expiresAt: TimeInterval) {
        self.url = url
        self.expiresAt = expiresAt
    }
}
