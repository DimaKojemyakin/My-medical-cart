//
//  CrateAccViewController.swift
//  My medical cart
//
//  Created by Дима Кожемякин on 06.10.2023.
//

import UIKit
import CoreData

class CrateAccView: UIViewController {
    
    @IBOutlet var phoneTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Установите делегата для текстовых полей
        phoneTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        
        
        phoneTF.keyboardType = .phonePad
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func doneButtonTapped(_ sender: Any) {
        // Проверяем, что текстовые поля не пустые
        guard let phone = phoneTF.text, !phone.isEmpty,
              let password = passwordTF.text, !password.isEmpty,
              let email = emailTF.text, !email.isEmpty else {
            // Выводим сообщение об ошибке, если поля пустые
            print("Пожалуйста, заполните все поля")
            let alertController = UIAlertController(title: "Error", message: "Incorrect password, email or phone", preferredStyle: .alert)
            
            // Добавляем кнопку "Ok"
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        // Инициализируем контекст CoreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        // Создаем нового пользователя
        if let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            // Присваиваем значения атрибутам сущности CoreData
            newUser.phone = phone
            newUser.password = password
            newUser.email = email
            
            // Сохраняем пользователя в CoreData
            do {
                try context.save()
                print("Новый пользователь успешно сохранен в CoreData!")
                guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
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
                performSegue(withIdentifier: "crateAccLogIn", sender: nil)
                
                
            } catch {
                print("Ошибка при сохранении нового пользователя: \(error)")
            }
            
        }
        
    }
}

extension CrateAccView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Скрыть клавиатуру при нажатии на кнопку "Готово"
        textField.resignFirstResponder()
        return true
    }
}
