//
//  ViewController.swift
//  IntermediateTraining
//
//  Created by Aleksey Kosov on 09.01.2023.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
    func didAddCompany(company: Company) {
        companies.append(company)
        
        // 2 - insert a new index path into tableView
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    
    var companies = [Company]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCompanies()
        
        if #available(iOS 15, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        navigationItem.title = "Companies"
        tableView.separatorColor = .white
        tableView.backgroundColor = .darkBlue
        tableView.contentInset = .zero
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
    }
    
    private func fetchCompanies() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            companies.forEach { company in
                print(company.name ?? "")
            }
            
            self.companies = companies
            self.tableView.reloadData()
            
        } catch let fetchErr {
            print("Failed to fetch companies", fetchErr)
        }
        
    }
    
    @objc func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .fullScreen
        
        createCompanyController.delegate = self
        
        present(navController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count // arbitrary
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        let company = companies[indexPath.row]
        
        cell.backgroundColor = .tealColor
        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = .boldSystemFont(ofSize: 16)
        return cell
        
    }
    
    
}

