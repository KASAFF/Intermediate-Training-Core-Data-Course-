//
//  CompaniesController+UITableView.swift
//  IntermediateTraining
//
//  Created by Aleksey Kosov on 10.01.2023.
//

import UIKit

extension CompaniesController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let company = self.companies[indexPath.row]
        let employeesController = EmployeesController()
        employeesController.company = company

        navigationController?.pushViewController(employeesController, animated: true)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let company = self.companies[indexPath.row]
            self.companies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(company)
            do {
                try context.save()
            } catch let saveErr {
                print("Failed to delete company:", saveErr)
            }
            
            completionHandler(true)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, _, completionHandler) in
            self.editHandlerFunction(action: action, indexPath: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .lightRed
        editAction.backgroundColor = .darkBlue
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    private func editHandlerFunction(action: UIContextualAction, indexPath: IndexPath) {
        print("editing")
        
        let editCompanyController = CreateCompanyController()
        editCompanyController.delegate = self
        editCompanyController.company = companies[indexPath.row]
        let navController = CustomNavigationController(rootViewController: editCompanyController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies available..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ?  150 : 0
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CompanyCell
        
        let company = companies[indexPath.row]
        
        cell.company = company
        
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
