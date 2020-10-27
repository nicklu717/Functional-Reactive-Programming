
let stringArray = ["1", "2", "aaa", "3", "4", "5", "6", "bbb", "7", "8"]


// MARK: - Procedural Programming
var result_1: [Int] = []
for string in stringArray {
    guard let int = Int(string) else { continue }
    if int % 2 == 0 {
        result_1.append(int)
    }
}
print(result_1)


// MARK: - Functional Programming
var result_2 = stringArray.compactMap { Int($0) }.filter { $0 % 2 == 0 }
print(result_2)


// MARK: - Functional Programming with Bad Naming
var result_3 = stringArray.compactMap { Int($0) }.filter_unknown { $0 % 2 == 0 }
print(result_3)











// MARK: - Array Extension
extension Array {
    func filter_unknown(_ isIncluded: (Element) -> Bool) -> [Element] {
        return filter { !isIncluded($0) }
    }
}
