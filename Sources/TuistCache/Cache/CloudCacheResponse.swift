import Foundation
import TuistCore
import TuistGraph
import TuistSupport

typealias CloudCacheResource = HTTPResource<CloudResponse<CloudCacheResponse>, CloudResponseError>
typealias CloudVerifyUploadResource = HTTPResource<CloudResponse<CloudVerifyUploadResponse>, CloudResponseError>

struct CloudHEADResponse: Decodable {}
struct CloudVerifyUploadResponse: Decodable {
    let uploadedSize: Int
}

protocol CloudCacheResourceManufacturing {
    func existsResource(hash: String) throws -> HTTPResource<CloudResponse<CloudHEADResponse>, CloudHEADResponseError>
    func fetchResource(hash: String) throws -> CloudCacheResource
    func storeResource(hash: String, contentMD5: String) throws -> CloudCacheResource
    func verifyUploadResource(hash: String, contentMD5: String) throws -> CloudVerifyUploadResource
}

class CloudCacheResourceFactory: CloudCacheResourceManufacturing {
    private let cloudConfig: Cloud

    init(cloudConfig: Cloud) {
        self.cloudConfig = cloudConfig
    }

    func existsResource(hash: String) throws -> HTTPResource<CloudResponse<CloudHEADResponse>, CloudHEADResponseError> {
        let url = try URL.apiCacheURL(hash: hash, cacheURL: cloudConfig.url, projectId: cloudConfig.projectId)
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        return HTTPResource(request: { request },
                            parse: { _, _ in CloudResponse(status: "HEAD", data: CloudHEADResponse()) },
                            parseError: { _, _ in CloudHEADResponseError() })
    }

    func fetchResource(hash: String) throws -> CloudCacheResource {
        let url = try URL.apiCacheURL(
            hash: hash,
            cacheURL: cloudConfig.url,
            projectId: cloudConfig.projectId
        )
        return jsonResource(for: url, httpMethod: "GET")
    }

    func storeResource(hash: String, contentMD5: String) throws -> CloudCacheResource {
        let url = try URL.apiCacheURL(
            hash: hash,
            cacheURL: cloudConfig.url,
            projectId: cloudConfig.projectId,
            contentMD5: contentMD5
        )
        return jsonResource(for: url, httpMethod: "POST")
    }

    func verifyUploadResource(hash: String, contentMD5: String) throws -> CloudVerifyUploadResource {
        let url = try URL.apiCacheVerifyUploadURL(
            hash: hash,
            cacheURL: cloudConfig.url,
            projectId: cloudConfig.projectId,
            contentMD5: contentMD5
        )
        return jsonResource(for: url, httpMethod: "POST")
    }

    private func jsonResource<R: Decodable>(for url: URL, httpMethod: String) -> HTTPResource<CloudResponse<R>, CloudResponseError> {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return .jsonResource { request }
    }
}

struct CloudCacheResponse: Decodable {
    let url: URL
    let expiresAt: TimeInterval

    init(url: URL, expiresAt: TimeInterval) {
        self.url = url
        self.expiresAt = expiresAt
    }
}
