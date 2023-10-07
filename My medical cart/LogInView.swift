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
    
    
    
    
    
    lazy var userNameLogin = ""
    lazy var passwordLogin = ""
    
    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        context = appDelegate.persistentContainer.viewContext
    }
    
    


}

