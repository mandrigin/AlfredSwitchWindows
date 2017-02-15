import Foundation

for command in CommandLine.commands() {
    switch command {
    case let searchCommand as SearchCommand:
        let foundWindows = Windows.all.search(query: searchCommand.query)
        print(AlfredDocument(withItems: foundWindows).xml.xmlString)
    default:
        print("Unknown command! Use --search=<query> to search for active windows.")
        exit(1)
    }
}

