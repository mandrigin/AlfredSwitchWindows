import Foundation

func search(query: String) {
    let foundWindows = Windows.all.search(query: query)
    print(AlfredDocument(withItems: foundWindows).xml.xmlString)
}

for command in CommandLine.commands() {
    switch command {
    case let searchCommand as SearchCommand:
        search(query: searchCommand.query)
        exit(0)
    default:
        print("Unknown command!")
        print("Commands:")
        print("--search=<query> to search for active windows/Safari tabs.")
        exit(1)
    }
}

