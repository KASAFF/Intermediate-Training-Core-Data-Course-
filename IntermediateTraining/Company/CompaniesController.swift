//
//  ViewController.swift
//  IntermediateTraining
//
//  Created by Aleksey Kosov on 09.01.2023.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {

    var companies = [Company]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.companies = CoreDataManager.shared.fetchCompanies()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
        if #available(iOS 15, *) {
            tableView.sectionHeaderTopPadding = 0
        }

        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        
        navigationItem.title = "Companies"
        tableView.separatorColor = .white
        tableView.backgroundColor = .darkBlue
        tableView.contentInset = .zero
        
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
    }
    

    @objc private func handleReset() {
        print("Attempting to delete all coredata objects")

        let context = CoreDataManager.shared.persistentContainer.viewContext

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            // upon deletion from core data succesded

            var indexPathsToRemove = [IndexPath]()

            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)


        } catch let deleteErr {
            print("Error with deleting all", deleteErr)
        }
    }

    @objc func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .fullScreen
        
        createCompanyController.delegate = self
        
        present(navController, animated: true)
    }
    
    
    
    
}

