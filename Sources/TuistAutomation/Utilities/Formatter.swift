import Foundation
import TuistCore
import TuistSupport

protocol Formatting {
    func buildArguments(quiet: Bool) throws -> [String]
}

final class Formatter: Formatting {
    private struct Arguments {
        static let quieter: String = "--quieter"
    }
    private let binaryLocator: BinaryLocating

    init(binaryLocator: BinaryLocating = BinaryLocator()) {
        self.binaryLocator = binaryLocator
    }

    func buildArguments(quiet: Bool) throws -> [String] {
        var args: [String] = [try binaryLocator.xcbeautifyPath().pathString]
        
        if quiet {
            args.append(Arguments.quieter)
        }
        
        return args
    }
}
