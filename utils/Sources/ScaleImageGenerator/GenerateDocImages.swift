
import ArgumentParser
import SystemPackage
import VisualTests

@main
struct GenerateDocImages: ParsableCommand {

    // I'm thinking to do something with rendering images using
    // https://developer.apple.com/documentation/swiftui/imagerenderer

    @Flag(help: "Include a counter with each repetition.")
    var includeCounter = false

    @Option(name: .shortAndLong, help: "The number of times to repeat 'phrase'.")
    var count: Int?

    @Argument(help: "The phrase to repeat.")
    var phrase: String

    mutating func run() throws {
        print("Hi")
        let repeatCount = count ?? 2

        for i in 1...repeatCount {
            if includeCounter {
                print("\(i): \(phrase)")
            } else {
                print(phrase)
            }
        }
    }
}
