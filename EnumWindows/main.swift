import Foundation

let foundWindows = WindowList.windows.search(query: CommandLine.searchQuery())

print(AlfredDocument(withItems: foundWindows).xml.xmlString)
