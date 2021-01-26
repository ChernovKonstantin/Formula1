////
////  ViewController.swift
////  F1Search
////
////  Created by Константин Чернов on 19.01.2021.
////
//
//import UIKit
//
//
//class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
//
//    var pickerData: [String] = [String]()
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 3
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return 100
//    }
//
//
//    let picker = UIPickerView()
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.picker.delegate = self
//                self.picker.dataSource = self
//
//
//        //pickerData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
//
//        picker.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(picker)
//
//
//        picker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        picker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        picker.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
//        picker.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//
//    }
//
//
//
//
//}
//
