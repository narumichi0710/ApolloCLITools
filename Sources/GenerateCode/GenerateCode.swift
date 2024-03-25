//
//  GenerateCode.swift
//
//
//  Created by Narumichi Kubo on 2024/03/25.
//

import Apollo
import ApolloCodegenLib
import ArgumentParser
import Foundation

@main
struct GenerateCode: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "generate",
        abstract: "Generates Swift code from the provided GraphQL schema"
    )

    mutating func run() async throws {
        #if os(macOS)
            let demoPath = "./Demo/Demo/"
            let schemaFilePaths = [demoPath + "Apollo/Generated/Schema/schema.graphqls"]
            let operationSearchPaths = ["./Demo/Demo/Operation/*.graphql"]
            let schemaConfigPath = demoPath + "Apollo/Generated/Operation/"
            let relativePath = "Generated/"

            let configuration = ApolloCodegenConfiguration(
                schemaNamespace: "GraphQL",
                input: .init(
                    schemaSearchPaths: schemaFilePaths,
                    operationSearchPaths: operationSearchPaths
                ),
                output: .init(
                    schemaTypes: ApolloCodegenConfiguration.SchemaTypesFileOutput(
                        path: schemaConfigPath,
                        moduleType: .embeddedInTarget(name: "Demo", accessModifier: .public)
                    ),
                    operations: .relative(subpath: relativePath, accessModifier: .public),
                    testMocks: .none
                )
            )
            try await ApolloCodegen.build(with: configuration)
        #endif
    }
}
