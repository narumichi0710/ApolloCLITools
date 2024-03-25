//
//  ResponseLoggingInterceptor.swift
//  Demo
//
//  Created by Narumichi Kubo on 2024/03/25.
//

import Apollo
import ApolloAPI
import Foundation

class ResponseLoggingInterceptor: ApolloInterceptor {
    var id: String = UUID().uuidString

    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) {
        defer {
            chain.proceedAsync(
                request: request,
                response: response,
                interceptor: self,
                completion: completion
            )
        }
        guard let response, let data = String(bytes: response.rawData, encoding: .utf8) else {
            chain.handleErrorAsync(
                ApolloError.fatal,
                request: request,
                response: response,
                completion: completion
            )
            return
        }
        debugPrint("HTTP Response: \(response.httpResponse) Data: \(data)")
    }
}
