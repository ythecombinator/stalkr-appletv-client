//
//  ProjectsTableViewController.swift
//  stalkr
//
//  Created by Edvaldo Junior on 15/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SidebarController: UITableViewController {

    let optionsNames: [String] = ["DASHBOARD", "NEW DASHBOARD", "MY ACCOUNT"]
    
    let icons: [UIImage] = [
        FAKMaterialIcons.viewDashboardIcon(withSize: 20).image(with: CGSize(width: 20, height: 20)),
        FAKIonIcons.plusCircledIcon(withSize: 20).image(with: CGSize(width: 20, height: 20)),
        FAKMaterialIcons.accountIcon(withSize: 20).image(with: CGSize(width: 20, height: 20)),
    ]
        
    var sidebarProtocol: SidebarProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let image = icons[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! TableCell
        
        let numberOfSpaces: Int = Int(cell.contentView.bounds.width / 70)
        var gap = " "
        
        for _ in 0...numberOfSpaces {
            gap += " "
        }
        
        cell.textLabel?.text = gap + optionsNames[indexPath.row]
        cell.imageView!.image = image
        
        return cell
    }
    
    // focus
    override func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if let next = context.nextFocusedIndexPath {
            sidebarProtocol?.focusedCell(withOption: optionsNames[next.row])
            
            let nextCell = tableView.cellForRow(at: next)! as! TableCell
            changeUiToFocused(cell: nextCell)
            if context.previouslyFocusedIndexPath == nil {
                nextCell.alpha = nextCell.defaultAlpha
            }
        }
        
        if let previously = context.previouslyFocusedIndexPath {
            let previousCell = tableView.cellForRow(at: previously)! as! TableCell
            
            changeUiToNotSelected(cell: previousCell)
            if context.nextFocusedIndexPath == nil {
                changeUiToSelected(cell: previousCell)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        sidebarProtocol?.selectedCell(withIndex: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func changeUiToNotSelected(cell: TableCell) {
        cell.contentView.backgroundColor = .clear
    }
    
    func changeUiToSelected(cell: TableCell) {
        
        cell.alpha = 1.0
        cell.contentView.backgroundColor = UIColor(netHex: 0x1B1D36)
    }
    
    func changeUiToFocused(cell: TableCell) {
        
        cell.contentView.backgroundColor = UIColor(netHex: 0x1B1D36)
        cell.contentView.backgroundColor = cell.contentView.backgroundColor?.withAlphaComponent(1)
    }
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
