//
//  EmployeesController.swift
//  IntermediateTraining
//
//  Created by Aleksey Kosov on 10.01.2023.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
        
    }


    var company: Company?

    var employees = [Employee]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }

    private func fetchEmployees() {
        print("Trying to fetch employees..")

        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request = NSFetchRequest<Employee>(entityName: "Employee")

        do {
            let employees = try context.fetch(request)
            self.employees = employees

        } catch let err {
            print("Failed to fetch employees", err)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        let employee = employees[indexPath.row]
        cell.textLabel?.text = employee.name
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = .boldSystemFont(ofSize: 15)

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        employees.count
    }

    let cellId = "celllld"

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchEmployees()
        tableView.backgroundColor = .darkBlue

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)

        setupPlusButtonInNavBar(selector: #selector(handleAdd))
    }

    @objc private func handleAdd() {
        print("Trying to add an employee")

        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        let navController = UINavigationController(rootViewController: createEmployeeController)
        navController.modalPresentationStyle = .fullScreen

        present(navController, animated: true)
    }

}
