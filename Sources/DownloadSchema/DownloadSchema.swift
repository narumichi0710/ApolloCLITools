//
//  DownloadSchema.swift
//
//
//  Created by Narumichi Kubo on 2024/03/25.
//

import Apollo
import ApolloCodegenLib
import ArgumentParser
import Foundation

@main
struct DownloadSchema: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "download",
        abstract: "Downloads the GraphQL schema"
    )

    mutating func run() async throws {
        #if os(macOS)
            let endpointUrl = URL(string: "https://swapi-graphql.netlify.app/.netlify/functions/index/graphql")!
            let outputPath = "./schema.graphqls"
            let configuration = ApolloSchemaDownloadConfiguration(
                using: .introspection(endpointURL: endpointUrl, outputFormat: .SDL),
                outputPath: outputPath
            )
            try await ApolloSchemaDownloader.fetch(configuration: configuration)
        #endif
    }
}
