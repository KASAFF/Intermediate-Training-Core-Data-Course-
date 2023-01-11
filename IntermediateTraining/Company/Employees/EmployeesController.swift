//
//  EmployeesController.swift
//  IntermediateTraining
//
//  Created by Aleksey Kosov on 10.01.2023.
//

import UIKit
import CoreData

// lets create a UILabel subclass for custom text drawing

class IndentedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let customRect = rect.insetBy(dx: 16, dy: 0)
        super.drawText(in: customRect)
    }
}

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {

    func didAddEmployee(employee: Employee) {
        guard let section = employeeTypes.firstIndex(of: employee.type!) else { return }

        let row = allEmployees[section].count - 1

        let newIndexPath = IndexPath(row: row,section: section)

        allEmployees[section].append(employee)

        tableView.insertRows(at: [newIndexPath], with: .middle)
    }
    var company: Company?

  //  var employees = [Employee]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()

        label.text = employeeTypes[section]

        label.backgroundColor = .lightBlue
        label.textColor = .darkBlue
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    var allEmployees = [[Employee]]()

    var employeeTypes = [
        EmployeeType.Intern.rawValue,
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue,
    ]

    private func fetchEmployees() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }

        // let's use my array and loop to filter instead

        allEmployees = []

        employeeTypes.forEach { employeeType in

            // somehow construct my allEmployees
            allEmployees.append(
                companyEmployees.filter { $0.type == employeeType}
            )
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        let employee = allEmployees[indexPath.section][indexPath.row]

       // let employee = employees[indexPath.row]
        cell.textLabel?.text = employee.fullName

        if let birthday = employee.employeeInformation?.birthday {

            let dateFromatter = DateFormatter()
            dateFromatter.dateFormat = "MMM dd, yyyy"

            cell.textLabel?.text = "\(employee.fullName ?? "")   \(dateFromatter.string(from: birthday))"
        }

        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = .boldSystemFont(ofSize: 15)

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count

    }
    let cellId = "celllld"

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 15, *) {
            tableView.sectionHeaderTopPadding = 0
        }

        fetchEmployees()
        tableView.backgroundColor = .darkBlue

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)

        setupPlusButtonInNavBar(selector: #selector(handleAdd))
    }

    @objc private func handleAdd() {
        print("Trying to add an employee")

        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        navController.modalPresentationStyle = .fullScreen

        present(navController, animated: true)
    }

}
