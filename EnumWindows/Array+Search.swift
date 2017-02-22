import Foundation

protocol Searchable {
    var searchStrings : [String] { get }
}

extension Array where Element:Searchable {
    func search(query: String) -> [Element] {
        guard query.characters.count > 0 else {
            return self
        }
        let components : ArraySlice<String> =
            ArraySlice(
                query.components(separatedBy:  " ")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { $0.characters.count > 0 }
            )
        return search(components: components)
    }
    
    private func search(components: ArraySlice<String>) -> [Element] {
        guard let q = components.first else {
            return self
        }
        
        let result = self.filter {
            let hits = $0.searchStrings.filter { $0.localizedCaseInsensitiveContains(q) }
            return hits.count > 0
        }
        
        return result.search(components: components.dropFirst(1))
    }
}
