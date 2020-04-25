//
//  ProductCategoryViewController.swift
//  OnTheGo
//
//  Created by Visal Hettiarachchi on 4/25/20.
//  Copyright © 2020 Visal Hettiarachchi. All rights reserved.
//

import UIKit

class ProductCategoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    private var categoryList = [ProductCategory]()
    private var categoryManager: ProductCategoryManager = ProductCategoryManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        if initService(){
            loadData()
        }
    }
    
    func initService()->Bool{
        self.tableView.dataSource = self
        self.tableView.delegate = self
        categoryManager.delegate = self
        return true
    }
    
    func loadData(){
        self.showWaitOverlay()
        categoryManager.getAllProductCategory()
    }
    
    //MARK: Actions
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        
        //ToDo: This has to be added to a new modal view controller
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a New Product Cateogry", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let catName = textField.text
            let isValidCat = self.categoryManager.validateProductCategory(catogoryName: catName)
            
            if isValidCat{
                let newCategory = ProductCategory(uid: nil, name: catName!)
                self.showWaitOverlay()
                self.categoryManager.createProductCategory(with: newCategory)
            }
            
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - UITableViewDataSource
extension ProductCategoryViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categoryList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableViewCells.ProductCategoryCell, for: indexPath) as! ProductCategoryTableViewCell
        cell.updateCell(with: category)
        
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension ProductCategoryViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Doesnt need this functionality to chat
    }
}

//MARK: - Product Category Manager Delegate
extension ProductCategoryViewController: ProductCategoryManagerDelegate{
    func didLoadProductCategories(_ productsCategoryManager: ProductCategoryManager, categories: [ProductCategory]) {
        categoryList.removeAll()
        for cat in categories{
            categoryList.append(cat)
            DispatchQueue.main.async {
                self.removeAllOverlays()
                self.tableView.reloadData()
            }
        }
    }
    
    func didCreateProductCategory(_ productsCategoryManager: ProductCategoryManager, category: ProductCategory) {
        //        self.categoryList.append(category)
        //        self.tableView.reloadData()
        //        self.removeAllOverlays()
        self.categoryManager.getAllProductCategory()
    }
    
    func didCreateProductCategoryFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.removeAllOverlays()
            AlertsHandler.showAlertWithErrorMessage(title: NSLocalizedString(K.Alert.ErrorTitle, comment: ""), message:NSLocalizedString(K.ErrorMessage.ProductCategory.create, comment: "") )
            print(error.localizedDescription, Date(), to: &Logger.log)
        }
        
    }
    
    func didValidateProductCategoryFailWithError(errorMessage: String) {
        AlertsHandler.showAlertWithErrorMessage(title: NSLocalizedString(K.Alert.ErrorTitle, comment: ""), message: errorMessage)
    }
    
    
}
