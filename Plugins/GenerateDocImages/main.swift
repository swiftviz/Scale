import Foundation
import PackagePlugin

@main
struct GenerateDocImages: CommandPlugin {
    func performCommand(context _: PluginContext, arguments _: [String]) async throws {
        print("Hi")
//        let tool = try context.tool(named: "swiftlint")
//        let toolUrl = URL(fileURLWithPath: tool.path.string)
//
//        for target in context.package.targets {
//            guard let target = target as? SourceModuleTarget else { continue }
//
//            let process = Process()
//            process.executableURL = toolUrl
//            process.arguments = [
//                "\(target.directory)",
//                "--fix",
//               // "--in-process-sourcekit" // this line will fix the issues...
//            ]
//
//            try process.run()
//            process.waitUntilExit()
//
//            if process.terminationReason == .exit && process.terminationStatus == 0 {
//                print("Formatted the source code in \(target.directory).")
//            }
//            else {
//                let problem = "\(process.terminationReason):\(process.terminationStatus)"
//                Diagnostics.error("swift-format invocation failed: \(problem)")
//            }
//        }
    }
}
