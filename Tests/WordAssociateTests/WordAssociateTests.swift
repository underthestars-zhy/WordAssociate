import XCTest
@testable import WordAssociate

final class WordAssociateTests: XCTestCase {
    func testAdd() {
        WordAssociate.shared.add("Test")
        WordAssociate.shared.add("Tesa")
        WordAssociate.shared.add("Teb")
    }
    
    func testHas() {
        WordAssociate.shared.add("Test")
        WordAssociate.shared.add("Tesa")
        WordAssociate.shared.add("Teb")
        
        XCTAssertEqual(WordAssociate.shared.has("Tesa"), true)
        XCTAssertEqual(WordAssociate.shared.has("Tes"), false)
    }
    
    @available(macOS 12.0.0, *)
    func testAddWithAsync() async {
        await withTaskGroup(of: Void.self, body: { group in
            group.addTask(priority: .userInitiated) {
                await WordAssociate.getWordAssociate(with: "test2").add("Test")
            }
            group.addTask(priority: .userInitiated) {
                await WordAssociate.getWordAssociate(with: "test2").add("Tesa")
            }
            group.addTask(priority: .userInitiated) {
                await WordAssociate.getWordAssociate(with: "test2").add("Tesb")
            }
        })
    }
    
}

final class WordAssociateSpeedTests: XCTestCase {
    let testWord = { () -> [String] in
        var res = [String]()
        for _ in 0...1000000 {
            res.append(String.randomStr(len: randomIn(min: 1, max: 30)))
        }
        return res
    }()
    
    func testFindWord() {
        for word in testWord {
            WordAssociate.shared.add(word)
        }
        
        self.measure {
            WordAssociate.shared.get("Abs")
            
            print(WordAssociate.shared.res)
        }
    }
    
    func testFindWordWithArray() {
        var a = [String]()
        
        for word in testWord {
            a.append(word)
        }
        
        self.measure {
            var res = [String]()
            
            for i in a {
                if i.lowercased().hasPrefix("Abs".lowercased()) { res.append(i) }
            }
            
            print(res)
        }
    }
}

func randomIn(min: Int, max: Int) -> Int {
    return Int(arc4random()) % (max - min + 1) + min
}

extension String{
    static let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static func randomStr(len : Int) -> String{
        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(random_str_characters.count)))
            ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
}
