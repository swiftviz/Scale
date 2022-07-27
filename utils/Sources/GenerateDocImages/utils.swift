@main
public struct utils {
    public private(set) var text = "Hello, World!"

    public static func main() {
        print(utils().text)
    }
}
