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

    @objc private func doWork() {
        print("tring to do work")
        // GCD - GrandCentralDispatch
            CoreDataManager.shared.persistentContainer.performBackgroundTask { backgroundContext in
                (0...5).forEach { value in
                    print(value)
                    let company = Company(context: backgroundContext)
                    company.name = String(value)
                }

                do {
                    try backgroundContext.save()

                    DispatchQueue.main.async {
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        self.tableView.reloadData()
                    }

                } catch let err {
                    print("failed to save:", err)
                }
            }
        // creating some Company objects on a background thread

    }

    // let's do some tricky updates with core data

    @objc private func doUpdates() {
        print("Trying to update comanies on a background context")

        CoreDataManager.shared.persistentContainer.performBackgroundTask { backgroundContext in

            let request: NSFetchRequest<Company> = Company.fetchRequest()

            do {
                let companies = try backgroundContext.fetch(request)

                companies.forEach { company in
                    print(company.name ?? "")
                    company.name = "C: \(company.name ?? "")"
                }
                do {
                    try backgroundContext.save()

                    // let's try to update the UI after a save

                    DispatchQueue.main.async {

                        // reset will forget all of the objects you fetch before

                        CoreDataManager.shared.persistentContainer.viewContext.reset()

                        // you dont want to refetch everyting if youre just simply update  one or two companies

                        self.companies = CoreDataManager.shared.fetchCompanies()

                        // is there a way to just merge the changes that you made onto the main view context?

                        self.tableView.reloadData()
                    }

                } catch let saveErr {
                    print("Failed to save on background:", saveErr)
                }

            } catch let err {
                print("Failed to fetch companies on background", err)
            }
        }
    }

    @objc private func doNestedUpdates() {
        print("Trying to perform nested updates now...")

        DispatchQueue.global(qos: .background).async {
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext

            // execute updated on privateContext now

            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            do {
                let companies = try privateContext.fetch(request)

                companies.forEach { company in
                    print(company.name ?? "")
                    company.name = "D: \(company.name ?? "")"
                }
                do {
                    try privateContext.save()

                    DispatchQueue.main.async {
                        do {
                            let context = CoreDataManager.shared.persistentContainer.viewContext

                            if context.hasChanges {
                                try context.save()
                            }
                            self.tableView.reloadData()
                        } catch let saveErr {
                            print("Failed to save main context:", saveErr)
                        }

                    }
                } catch let saveErr {
                    print("Failed to save on private context:", saveErr)
                }

            } catch let fetchErr {
                print("Failed to fetch on private context:", fetchErr)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.companies = CoreDataManager.shared.fetchCompanies()

        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Nested Updates", style: .plain, target: self, action: #selector(doNestedUpdates))
        ]
        
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

