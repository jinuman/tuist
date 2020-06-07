import Foundation
import RxSwift
import TSCBasic
import TuistCore
import TuistSupport

// TODO: Later, add a warmup function to check if it's correctly authenticated ONCE
final class CacheRemoteStorage: CacheStoring {
    // MARK: - Attributes

    private let cloudClient: CloudClienting

    // MARK: - Init

    init(cloudClient: CloudClienting) {
        self.cloudClient = cloudClient
    }

    // MARK: - CacheStoring

    func exists(hash: String, config: Config) throws -> Single<Bool> {
        let resource = try CloudHEADResponse.existsResource(hash: hash, config: config)
        return cloudClient.request(resource).map { response in
            let successRange = 200 ..< 300
            return successRange.contains(response.response.statusCode)
        }
    }

    func fetch(hash: String, config: Config) throws -> Single<AbsolutePath> {
        let resource = try CloudCacheResponse.fetchResource(hash: hash, config: config)
        return cloudClient.request(resource).map { _ in
            AbsolutePath.root // TODO:
        }
    }

    func store(hash: String, config: Config, xcframeworkPath _: AbsolutePath) throws -> Completable {
        let resource = try CloudCacheResponse.storeResource(hash: hash, config: config)
        return cloudClient.request(resource).map { responseTuple in
            let cacheResponse = responseTuple.object.data
            let artefactToDownloadURL = cacheResponse.url
            print(artefactToDownloadURL)
            // TODO: Download file at given url
        }.asCompletable()
    }
}
