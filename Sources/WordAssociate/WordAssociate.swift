import SwiftUI

@available(iOS 13.0.0, *)
@available(watchOS 6.0.0, *)
@available(tvOS 12.0.0, *)
@available(macOS 10.15, *)
public class WordAssociate: ObservableObject {
    public static let shared = WordAssociate()
    static let poolLock = NSLock()
    static var pool = [String : WordAssociate]()
    public static func getWordAssociate(with name: String) -> WordAssociate {
        if let wa = pool[name] { return wa } else {
            let wa = WordAssociate()
            poolLock.lock()
            pool[name] = wa
            poolLock.unlock()
            return wa
        }
    }
    
    @Published var res = [String]()
    
    let letterTable = LetterTable()
    
    @available(macOS 12.0.0, *)
    @available(iOS 15.0.0, *)
    @available(watchOS 8.0.0, *)
    @available(tvOS 15.0.0, *)
    public func add(_ word: String) async { Task(priority: .background) { add(word) } }
    
    public func add(_ word: String) {
        var tempTable = letterTable
        
        for (index, char) in word.enumerated() {
            let subString = String(char).lowercased()
            
            tempTable = tempTable.add(char: subString, end: index == (word.count - 1))
        }
        
        // print(letterTable.hashTable["t"]?.hashTable["e"]?.hashTable["s"]?.hashTable)
    }
    
    public func `get`(_ word: String) {
        var tempLetterTable = letterTable
        
        res = []
        
        for (index, char) in word.enumerated() {
            let subString = String(char).lowercased()
            
            if index == word.count - 1 {
                if tempLetterTable.wordTable.contains(subString) {
                    res.append(word)
                }
            }
            
            if let table = tempLetterTable.hashTable[subString] {
                tempLetterTable = table
            } else {
                return
            }
        }
        
        func deepFind(_ lastWord: String) {
            for item in tempLetterTable.wordTable {
                res.append(lastWord + item)
            }
            
            guard !tempLetterTable.hashTable.isEmpty else { return }
            
            for value in tempLetterTable.hashTable {
                tempLetterTable = value.value
                deepFind(lastWord + value.key)
            }
        }
        
        deepFind(word)
    }
    
    init() {}
}

class LetterTable {
    var wordTable: Set<String> = []
    var hashTable = [String : LetterTable]()
    
    let hashTableLock = NSLock()
    let wordTableLock = NSLock()
    
    func add(char: String, end: Bool) -> LetterTable {
        if let sub = hashTable[char] {
            wordTableLock.lock()
            if end { wordTable.insert(char) }
            wordTableLock.unlock()
            return sub
        } else {
            let lt = LetterTable()
            wordTableLock.lock()
            if end { wordTable.insert(char) }
            wordTableLock.unlock()
            hashTableLock.lock()
            hashTable[char] = lt
            hashTableLock.unlock()
            return lt
        }
    }
    
    init() { }
}

extension String {
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
}
