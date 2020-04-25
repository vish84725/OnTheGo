//
//  ProductsViewController.swift
//  OnTheGo
//
//  Created by Visal Hettiarachchi on 4/25/20.
//  Copyright © 2020 Visal Hettiarachchi. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    private var productList = [Product]()
    private var productManager: ProductsManager = ProductsManager()
    
    var selectedProductCategory: ProductCategory? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if initService(){
        }
    }
    
    func initService()->Bool{
        self.tableView.dataSource = self
        self.tableView.delegate = self
        productManager.delegate = self
        return true
    }
    
    func loadData(){
        self.showWaitOverlay()
        productManager.getAllProduct(catId: selectedProductCategory!.uid!)
    }
    
    //MARK: Actions
    @IBAction func addProductButtonPressed(_ sender: Any) {
        //ToDo: This has to be added to a new modal view controller
        var nameTextField = UITextField()
        var amountTextField = UITextField()
        
        let alert = UIAlertController(title: "Add a New Product", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let prodName = nameTextField.text
            let prodQuantity = amountTextField.text == "" ? 0 :Int(amountTextField.text!)
            
            
            
            let isValidCat = self.productManager.validateProduct(name: prodName, quantity: prodQuantity)
            
            if isValidCat{
                let newProd = Product(uid: nil, name: prodName!, categoryId: self.selectedProductCategory!.uid!, quantity: prodQuantity!)
                self.showWaitOverlay()
                self.productManager.createProduct(with: newProd)
            }
            
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            nameTextField = field
            nameTextField.placeholder = "Add a new product"
        }
        
        alert.addTextField { (field) in
            amountTextField = field
            amountTextField.placeholder = "Enter the quantity"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - UITableViewDataSource
extension ProductsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let product = productList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableViewCells.ProductCell, for: indexPath) as! ProductTableViewCell
        cell.updateCell(with: product)
        
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension ProductsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Doesnt need this functionality to chat
    }
}

//MARK: - Product Manager Delegate
extension ProductsViewController: ProductManagerDelegate{
    func didCreateProduct(_ productsManager: ProductsManager, product: Product) {
        self.productManager.getAllProduct(catId: selectedProductCategory!.uid!)
    }
    
    func didCreateProductFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.removeAllOverlays()
            AlertsHandler.showAlertWithErrorMessage(title: NSLocalizedString(K.Alert.ErrorTitle, comment: ""), message:NSLocalizedString(K.ErrorMessage.Product.create, comment: "") )
            print(error.localizedDescription, Date(), to: &Logger.log)
        }
    }
    
    func didValidateProductFailWithError(error: String) {
        
        AlertsHandler.showAlertWithErrorMessage(title: NSLocalizedString(K.Alert.ErrorTitle, comment: ""), message: error)
    }
    
    func didLoadProducts(_ productsManager: ProductsManager, products: [Product]) {
        productList.removeAll()
        DispatchQueue.main.async {
            self.removeAllOverlays()
            for prod in products{
                self.productList.append(prod)
                
            }
            self.tableView.reloadData()
        }
        
    }
}
