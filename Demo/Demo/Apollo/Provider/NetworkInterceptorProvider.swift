//
//  NetworkInterceptorProvider.swift
//  Demo
//
//  Created by Narumichi Kubo on 2024/03/25.
//

import Apollo
import ApolloAPI
import Foundation

struct NetworkInterceptorProvider: InterceptorProvider {
    private let store: ApolloStore
    private let client: URLSessionClient

    init(store: ApolloStore, client: URLSessionClient) {
        self.store = store
        self.client = client
    }

    func interceptors(for operation: some GraphQLOperation) -> [ApolloInterceptor] {
        [
            CacheReadInterceptor(store: store),
            RequestLoggingInterceptor(),
            NetworkFetchInterceptor(client: client),
            ResponseLoggingInterceptor(),
            ResponseCodeInterceptor(),
            JSONResponseParsingInterceptor(),
            AutomaticPersistedQueryInterceptor(),
            CacheWriteInterceptor(store: store)
        ]
    }
}
