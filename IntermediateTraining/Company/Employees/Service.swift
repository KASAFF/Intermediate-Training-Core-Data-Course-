//
//  Service.swift
//  IntermediateTraining
//
//  Created by Aleksey Kosov on 11.01.2023.
//

import Foundation
import CoreData

struct Service {

    static let shared = Service()

    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"

    func downloadcompaniesFromServer() {
        print("Attempting to download companies")

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, err in

            print("Finish downloading")

            if let err = err {
                print("Failed to download companies:", err)
                return
            }
            guard let data = data else { return }

            let jsonDecoder = JSONDecoder()

            do {
                let jsonCompnaies = try jsonDecoder.decode([JSONCompany].self, from: data)
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext

                jsonCompnaies.forEach { jsonCompany in
                    print(jsonCompany.name)
                    let company = Company(context: privateContext)
                    company.name = jsonCompany.name

                    company.numEmployees = 1
                    company.imageData = Data()

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let foundedDate = dateFormatter.date(from: jsonCompany.founded ?? "")
                    company.founded = foundedDate

                    jsonCompany.employees?.forEach({ jsonEmployee in
                    print("  \(jsonEmployee.name)")

                        let employee = Employee(context: privateContext)
                        employee.fullName = jsonEmployee.name
                        employee.type = jsonEmployee.type
                        let employeeInformation = EmployeeInformation(context: privateContext)
                        let birthdayDate = dateFormatter.date(from: jsonEmployee.birthday)

                        employeeInformation.birthday = birthdayDate
                        employee.employeeInformation = employeeInformation

                        employee.company = company
                    })
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                    } catch let saveErr {
                        print("Failed to save companies:", saveErr)
                    }
                }

            } catch let jsonDecodeErr {
                print(jsonDecodeErr)
            }
        }.resume() // please do not forget to make this call
    }
}

struct JSONCompany: Decodable {
    let name: String
    let founded: String?
    let photoUrl: String
    let employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    let name: String
    let type: String
    let birthday: String
}
