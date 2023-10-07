//
//  PersonalInfoTableViewCell.swift
//  My medical cart
//
//  Created by Дима Кожемякин on 06.10.2023.
//

import UIKit

class PersonalInfoTableViewCell: UITableViewCell {
    
    
    
    
    @IBOutlet var viewAvatar: UIImageView!
    @IBOutlet var lableAge: UILabel!
    @IBOutlet var lableFullName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        traitCollectionDidChange(nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Проверяем, изменился ли цветовой режим (светлый/темный режим)
        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                // Изменяем фотографию в зависимости от текущего цветового режима
                if self.traitCollection.userInterfaceStyle == .dark {
                    let imageDark = UIImage(named: "ваш аватар dark")
                    viewAvatar.image = imageDark
                } else {
                    let imageLight = UIImage(named: "ваш аватар 2")
                    viewAvatar.image = imageLight
                }
                
                // Оповещаем делегата о смене цветовой схемы
                
            }
        }
    }
    
    
}


