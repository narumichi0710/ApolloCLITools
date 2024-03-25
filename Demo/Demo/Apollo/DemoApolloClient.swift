//
//  DemoApolloClient.swift
//  Demo
//
//  Created by Narumichi Kubo on 2024/03/25.
//

import Apollo
import Foundation

public struct DemoApolloClient {
    public init() {}

    public let client: ApolloClient = {
        let client = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = NetworkInterceptorProvider(store: store, client: client)
        let url = URL(string: "https://swapi-graphql.netlify.app/.netlify/functions/index")!
        let transport = RequestChainNetworkTransport(
            interceptorProvider: provider,
            endpointURL: url
        )
        return ApolloClient(networkTransport: transport, store: store)
    }()
}

enum ApolloError: Error {
    case fatal
}
