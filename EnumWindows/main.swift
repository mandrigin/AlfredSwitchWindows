import Foundation

let foundWindows = Windows.all.search(query: CommandLine.searchQuery())

print(AlfredDocument(withItems: foundWindows).xml.xmlString)
