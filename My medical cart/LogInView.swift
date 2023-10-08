//
//  ViewController.swift
//  My medical cart
//
//  Created by Дима Кожемякин on 06.10.2023.
//

import UIKit
import CoreData

class LogInView: UIViewController {
    
    @IBOutlet var loginTF: UITextField!
    
    @IBOutlet var passwordTF: UITextField!
    
    
    
    
    
    
    
    var context: NSManagedObjectContext!
    
    override func loadView() {
        super.loadView()
        
        
        checkUserLoggedIn()
        
        loginTF.text = ""
        passwordTF.text = ""
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        context = appDelegate.persistentContainer.viewContext
        
        // Установите делегата для текстовых полей
        loginTF.delegate = self
        passwordTF.delegate = self
        
        navigationItem.hidesBackButton = true
        
        
        
        
    }
    func showEmailForPhoneNumber() {
        let alertController = UIAlertController(title: "Enter your phone number", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "phone"
            textField.keyboardType = .phonePad
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] (_) in
            guard let phoneNumber = alertController.textFields?.first?.text else { return }
            
            if self?.checkUserExistence(forPhoneNumber: phoneNumber) ?? false {
                self?.showEmail(for: phoneNumber)
            } else {
                let errorAlertController = UIAlertController(title: "Error", message: "User not found", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                errorAlertController.addAction(okAction)
                self?.present(errorAlertController, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }


    func checkUserExistence(forEmail email: String) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Error checking user existence: \(error)")
            return false
        }
    }
    func showEmail(for phoneNumber: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate(format: "phone == %@", phoneNumber)

        do {
            let users = try context.fetch(request) as? [User]
            if let user = users?.first, let email = user.email {
                let alertControllerResult = UIAlertController(title: "Your email is \(email)", message: nil, preferredStyle: .alert)
                let okActionEmail = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertControllerResult.addAction(okActionEmail)
                present(alertControllerResult, animated: true)
            } else {
                print("Email пользователя не найден")
                // Показать сообщение об ошибке, если email отсутствует
            }
        } catch {
            print("Ошибка при получении email пользователя: \(error)")
        }
    }

    func showPasswordForPhoneNumber() {
        let alertController = UIAlertController(title: "Enter your phone number", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "phone "
            textField.keyboardType = .phonePad
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] (_) in
            guard let phoneNumber = alertController.textFields?.first?.text else { return }
            
            if self?.checkUserExistence(forPhoneNumber: phoneNumber) ?? false {
                self?.showPassword(for: phoneNumber)
            } else {
                let errorAlertController = UIAlertController(title: "Error", message: "User not found", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                errorAlertController.addAction(okAction)
                self?.present(errorAlertController, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    func showPassword(for phoneNumber: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate(format: "phone == %@", phoneNumber)

        do {
            let users = try context.fetch(request) as? [User]
            if let user = users?.first, let password = user.password {
                let alertControllerResult = UIAlertController(title: "Your password is \(password)", message: nil, preferredStyle: .alert)
                let okActionPassword = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertControllerResult.addAction(okActionPassword)
                present(alertControllerResult, animated: true)
            } else {
                print("Пароль пользователя не найден")
                // Показать сообщение об ошибке, если пароль отсутствует
            }
        } catch {
            print("Ошибка при получении пароля пользователя: \(error)")
        }
    }

    
    func checkUserExistence(forPhoneNumber phoneNumber: String) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate(format: "phone == %@", phoneNumber)
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Error checking user existence: \(error)")
            return false
        }
    }

    
    func checkUserLoggedIn() {
        // Проверяем, зарегистрирован ли пользователь в Core Data
        // Предполагается, что в вашем случае это поле называется "registredUser"
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("AppDelegate is nil")
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate(format: "registredUser == %@", NSNumber(value: true))
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                // Пользователь уже зарегистрирован, переходим на другой экран
                performSegue(withIdentifier: "logIn", sender: nil)
            } else {
                // Пользователь не зарегистрирован
                print("Пользователь не зарегистрирован")
            }
        } catch {
            print("Ошибка при запросе данных из CoreData: \(error)")
        }
    }
    
    @IBAction func forgetPasswordButtonPressed(_ sender: Any) {
        showPasswordForPhoneNumber()
    }
    
    @IBAction func forgetEmailButtonPressed(_ sender: UIButton) {
        showEmailForPhoneNumber()
    }
    
    @IBAction func logInTapped(_ sender: UIButton) {
        
        
        // Проверяем, что email и пароль не пустые
        guard let email = loginTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty else {
            print("Не правильный пороль или email")
            let alertController = UIAlertController(title: "Error", message: "Incorrect password or email", preferredStyle: .alert)
            // Добавляем кнопку "Ok"
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        // Проверяем, есть ли пользователь с введенным email и паролем в CoreData
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                // Если есть совпадение, переходим на другой экран
                performSegue(withIdentifier: "logIn", sender: nil)
                guard let appdelegate = UIApplication.shared.delegate as?  AppDelegate else {return}
                let contexting = appdelegate.persistentContainer.viewContext
                if let infologin = NSEntityDescription.insertNewObject(forEntityName: "User", into: contexting) as? User {
                    infologin.registredUser = true
                    
                    do {
                        try contexting.save()
                        print("Новый пользователь успешно сохранен в CoreData!")
                    } catch {
                        print("Ошибка при сохранении нового пользователя: \(error)")
                        
                    }
                    
                }
                
                
            } else {
                // Если нет совпадения, выводим сообщение об ошибке
                print("Пользователь с таким email и паролем не найден")
                let alertController = UIAlertController(title: "Error", message: "User not found", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            }
        } catch {
            print("Ошибка при запросе данных из CoreData: \(error)")
        }
    }
}



extension LogInView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Скрыть клавиатуру при нажатии на кнопку "Готово"
        textField.resignFirstResponder()
        return true
    }
}
