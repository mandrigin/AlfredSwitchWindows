import Foundation

extension Array where Element:WindowInfo {
    func search(query: String) -> [WindowInfo] {
        guard query.characters.count > 0 else {
            return self
        }
        let components : ArraySlice<String> = ArraySlice(query.components(separatedBy:  " "))
        return search(components: components)
    }
    
    private func search(components: ArraySlice<String>) -> [WindowInfo] {
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
