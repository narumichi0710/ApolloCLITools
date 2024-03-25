//
//  RequestLoggingInterceptor.swift
//  Demo
//
//  Created by Narumichi Kubo on 2024/03/25.
//

import Apollo
import ApolloAPI
import Foundation

class RequestLoggingInterceptor: ApolloInterceptor {
    var id: String = UUID().uuidString

    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) {
        debugPrint("API Request: \(request)")
        chain.proceedAsync(
            request: request,
            response: response,
            interceptor: self,
            completion: completion
        )
    }
}
