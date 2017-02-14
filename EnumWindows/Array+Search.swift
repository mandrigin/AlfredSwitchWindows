import Foundation

extension Array where Element:WindowInfo {
    func search(query: String) -> [WindowInfo] {
        guard query.characters.count > 0 else {
            return self
        }
        let components : ArraySlice<String> = ArraySlice(query.components(separatedBy:  " "))
        return search(components: components)
    }
    
    func search(components: ArraySlice<String>) -> [WindowInfo] {
        guard let q = components.first else {
            return self
        }
        
        let result = self.filter {
            let nameHit = $0.name.localizedCaseInsensitiveContains(q)
            let processHit = $0.processName.caseInsensitiveCompare(q) == ComparisonResult.orderedSame
            return nameHit || processHit
        }
        
        return result.search(components: components.dropFirst(1))
    }
}
