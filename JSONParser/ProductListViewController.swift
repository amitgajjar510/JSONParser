//
//  ProductListViewController.swift
//  JSONParser
//
//  Created by doxper on 17/06/19.
//  Copyright © 2019 amitgajjar. All rights reserved.
//

import UIKit

enum SortBy: String, CaseIterable {
    case popularityHighToLow = "Popularity: High to Low"
    case popularityLowToHigh = "Popularity: Low to High"
    case priceLowToHigh = "Price: Low to High"
    case priceHighToLow = "Price: High to Low"
}

class ProductListViewController: UIViewController {
    
    // MARK: Properties & Outlets
    @IBOutlet weak var productListTableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var productList: ProductList?
    var sortBy: SortBy = .popularityHighToLow
    
    // MARK: View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProductList()
    }
    
    // MARK: Action Methods
    @objc internal func sortButtonClicked() {
        if productList != nil && productList?.products.count != 0 {
            showSortByAlertController()
        }
    }

    // MARK: Private Methods
    private func initializeView() {
        title = "Products"
        
        addRightNavigationItems()
        
        productListTableView.register(UINib(nibName: "ProductListTableCell", bundle: nil), forCellReuseIdentifier: "ProductListTableCell")
        productListTableView.tableFooterView = UIView()
    }
    
    private func addRightNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SORT BY", style: UIBarButtonItem.Style.done, target: self, action: #selector(sortButtonClicked))
    }
    
    private func showSortByAlertController() {
        let alertController = UIAlertController(title: "SORT BY", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        SortBy.allCases.forEach { (sortBy) in
            let alertAction = UIAlertAction(title: sortBy.rawValue, style: UIAlertAction.Style.default, handler: { [weak self] (action) in
                DispatchQueue.main.async {
                    self?.loading.startAnimating()
                }
                self?.sortBy = sortBy
                self?.updateProductListView()
            })
            alertController.addAction(alertAction)
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func showAlertController(forMessage message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func updateProductListView() {
        if productList != nil && productList?.products.count != 0 {
            productList?.sortProducts(withSortByOption: sortBy)
            DispatchQueue.main.async { [weak self] in
                let indexPath = IndexPath(row: 0, section: 0)
                self?.productListTableView.reloadData()
                self?.productListTableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                self?.loading.stopAnimating()
            }
        }
    }
}

// MARK: -
extension ProductListViewController: UITableViewDataSource {
    // MARK: UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "ProductListTableCell", for: indexPath)
        let product = productList?.products[indexPath.row]
        (tableCell as? ProductListTableCell)?.fillCellData(forTag: indexPath.row, product: product)
        return tableCell
    }
}

// MARK: -
extension ProductListViewController {
    // MARK: API Calls
    fileprivate func fetchProductList() {
        guard let url = URL(string: "https://s3.ap-south-1.amazonaws.com/ss-local-files/products.json")
            else {
                showAlertController(forMessage: "Error in creating url")
                return
        }
        loading.startAnimating()
        guard let data = try? Data(contentsOf: url)
            else {
                showAlertController(forMessage: "Error in fetching data")
                loading.stopAnimating()
                return
        }
        productList = try? JSONDecoder().decode(ProductList .self, from: data)
        productList?.updateProducts()
        updateProductListView()
    }
}
