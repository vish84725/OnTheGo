//
//  ResgieterServiceProviderViewController.swift
//  OnTheGo
//
//  Created by Visal Hettiarachchi on 4/24/20.
//  Copyright © 2020 Visal Hettiarachchi. All rights reserved.
//

import UIKit

class ResgieterServiceProviderViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nicTextField: UITextField!
    @IBOutlet weak var productCategoryTextField: UITextField!
    
    private var selectedCategory: ProductCategory?
    private var categoryList = [ProductCategory]()
    private var categoryManager: ProductCategoryManager = ProductCategoryManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if initService(){
            loadData()
        }
    }
    
    private func initService()->Bool{
        categoryManager.delegate = self
        createPickerView()
        dismissPickerView()
        return true
    }
    
    private func loadData(){
        self.showWaitOverlay()
        categoryManager.getAllProductCategory()
    }
    
    //MARK: Actions
    @IBAction func registerProviderButtonPressed(_ sender: UIButton) {
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        productCategoryTextField.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        productCategoryTextField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        view.endEditing(true)
    }
}

//MARK: - UIPickerView Delegate
extension ResgieterServiceProviderViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row].name
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categoryList[row]
        productCategoryTextField.text = selectedCategory?.name
    }
}
//MARK: - UIPickerView Data Source
extension ResgieterServiceProviderViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    
}

//MARK: - TextField Delegate
extension ResgieterServiceProviderViewController: UITextFieldDelegate{
    
}

//MARK: - Product Category Manager Delegate
extension ResgieterServiceProviderViewController: ProductCategoryManagerDelegate{
    func didCreateProductCategory(_ productsCategoryManager: ProductCategoryManager, category: ProductCategory) {
        //Not Needed
    }
    
    func didCreateProductCategoryFailWithError(error: Error) {
        //Not Needed
    }
    
    func didValidateProductCategoryFailWithError(errorMessage: String) {
        //Not Needed
    }
    
    func didLoadProductCategories(_ productsCategoryManager: ProductCategoryManager, categories: [ProductCategory]) {
        categoryList = categories
        DispatchQueue.main.async {
            self.removeAllOverlays()
        }
    }
    
    
}
