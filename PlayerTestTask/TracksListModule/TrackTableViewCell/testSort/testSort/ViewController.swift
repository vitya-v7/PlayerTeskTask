//
//  ViewController.swift
//  testSort
//
//  Created by Admin on 28.11.2022.
//

import UIKit

class ViewController: UIViewController {
    private let array: [Float] = [1, 4, 7, 10, 12, 15, 16]
    override func viewDidLoad() {
        super.viewDidLoad()
        print(SortHelper.shared.findElement(16, inArray: array))
        // Do any additional setup after loading the view.
    }
    

}

