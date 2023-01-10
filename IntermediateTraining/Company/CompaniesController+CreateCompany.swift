//
//  CompaniesController+CreateCompany.swift
//  IntermediateTraining
//
//  Created by Aleksey Kosov on 10.01.2023.
//

import UIKit

extension CompaniesController: CreateCompanyControllerDelegate {
    func didEditCompany(company: Company) {
        guard let row = companies.firstIndex(of: company) else { return }
        let reloadIndexPath = IndexPath(row: row, section: 0)

        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }

    func didAddCompany(company: Company) {
        companies.append(company)

        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}
