import UIKit

let array = [1, 2, 4, -4, 5, 0, -3, 7, 3]
let filtered = array.filter { $0 < 3 }
print(filtered[2])
