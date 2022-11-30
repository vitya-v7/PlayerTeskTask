//
//  SortHelper.swift
//  testSort
//
//  Created by Admin on 28.11.2022.
//

import Foundation

class SortHelper {
    typealias df = Int
    static let shared = SortHelper()
    private init() {}
    func sortPlease<T: Comparable>(_ array: [T]) -> [T] {
        
        guard array.count > 1 else {
            return array
        }
        
        
        
        var subArray1 = self.aFunction(numbers: array,
                                       fromPosition: 0,
                                       toPosition: array.count / 2)
        
        var subArray2 = self.aFunction(numbers: array,
                                       fromPosition: array.count / 2 + 1,
                                       toPosition: array.count - 1)
        if subArray1.isEmpty {
            return subArray2
        }
        
        if subArray2.isEmpty {
            return subArray1
        }
//
//        if subArray1.count == 1 &&
//            subArray2.count == 1,
//           let minValue = array.min(),
//           let maxValue = array.max() {
//            return [minValue, maxValue]
//        }
        subArray1 = self.sortPlease(subArray1)
        subArray2 = self.sortPlease(subArray2)
     
        
        var sortedArray: [T] = []
        var index1 = 0
        var index2 = 0
        let count = min(subArray1.count, subArray2.count)
        for i in 0 ..< count {
            let incrementedArray = subArray1
            sortedArray.append(min(subArray1[index1], subArray2[index2]))
            
        }
        for (item1, item2) in zip(subArray1, subArray2) {
            sortedArray.append(min(item1, item2))
            sortedArray.append(max(item1, item2))
        }
        let maxArray = subArray1.count > subArray2.count ? subArray1 : subArray2
        let maxCount = max(subArray1.count, subArray2.count)
        let minCount = min(subArray1.count, subArray2.count)
        for index in minCount ..< maxCount {
            sortedArray.append(maxArray[index])
        }
     
        return sortedArray
        
    }
    
    func aFunction<T>(numbers: Array<T>,
                      fromPosition: Int,
                      toPosition: Int) -> Array<T> {
        guard fromPosition <= toPosition,
              numbers.indices.contains(fromPosition),
              numbers.indices.contains(toPosition) else {
                  return []
              }
        return Array(numbers[fromPosition ... toPosition])
    }
    
    func findElement(_ element: Float,
                     inArray array: [Float]) -> Int {
        let midElementIndex = array.count / 2
        let midElement = array[midElementIndex]
        if element == midElement {
            return midElementIndex
        }
        if element > midElement {
            let arr = Array(array[midElementIndex ..< array.count])
            return findElement(element, inArray: arr)
        } else {
            let arr = Array(array[0 ..< midElementIndex])
            return findElement(element, inArray: arr)
        }
    }
}
