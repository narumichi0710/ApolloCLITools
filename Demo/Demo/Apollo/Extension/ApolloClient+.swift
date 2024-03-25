//
//  ApolloClient+.swift
//  Demo
//
//  Created by Narumichi Kubo on 2024/03/25.
//

import Apollo
import ApolloAPI
import Foundation

public extension ApolloClient {
    func fetchQuery<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .default,
        contextIdentifier: UUID? = nil,
        queue: DispatchQueue = .main
    ) async -> Result<Query.Data, Error> {
        await withCheckedContinuation { continuation in
            fetch(
                query: query,
                cachePolicy: cachePolicy,
                contextIdentifier: contextIdentifier,
                queue: queue
            ) { result in
                switch result {
                case let .success(result):
                    if let data = result.data, result.errors == nil {
                        continuation.resume(returning: .success(data))
                    } else {
                        continuation.resume(returning: .failure(ApolloError.fatal))
                    }
                case let .failure(error):
                    continuation.resume(returning: .failure(error))
                }
            }
        }
    }

    func watchQuery<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .default,
        callbackQueue: DispatchQueue = .main
    ) -> AsyncThrowingStream<Query.Data, Error> {
        AsyncThrowingStream { continuation in
            let watcher = watch(query: query, cachePolicy: cachePolicy) { result in
                switch result {
                case let .success(result):
                    if let data = result.data, result.errors == nil {
                        continuation.yield(data)
                    } else {
                        continuation.finish(throwing: ApolloError.fatal)
                    }
                case let .failure(error):
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { @Sendable _ in
                watcher.cancel()
            }
        }
    }
}
