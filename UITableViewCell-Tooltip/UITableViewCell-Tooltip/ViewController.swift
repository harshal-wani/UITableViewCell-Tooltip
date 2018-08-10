//
//  ViewController.swift
//  UITableViewCell-Tooltip
//
//  Created by Harshal Wani on 8/10/18.
//  Copyright © 2018 Harshal Wani. All rights reserved.
//

import UIKit

class ResponsiveView: UIView {
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    var responsiveView: ResponsiveView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        
        longPressGR.minimumPressDuration = 0.3 // how long before menu pops up
        self.tableView.addGestureRecognizer(longPressGR)
        longPressGR.delegate = self
    }
    
    //MARK: Event handlers
    
    @objc func longPressHandler(sender: UILongPressGestureRecognizer) {
        
        guard sender.state == .began
            else { return }
        
        let pnt = sender.location(in: self.tableView)
        if let indexPath = tableView.indexPathForRow(at: pnt) {
            
            let currentCell = tableView.cellForRow(at: indexPath)
            
            responsiveView = nil
            responsiveView = ResponsiveView()
            
            // Add our responsive view to a super view
            responsiveView.frame = CGRect(x: 200, y: 200, width: 100, height: 100)
            responsiveView.center = self.view.center
            responsiveView.backgroundColor = UIColor.blue
            responsiveView.layer.cornerRadius = 4;
            responsiveView.layer.masksToBounds = true
            
            // Add a long press gesture recognizer to our responsive view
            responsiveView.isUserInteractionEnabled = true
            responsiveView.becomeFirstResponder()
            currentCell?.contentView.addSubview(responsiveView)
            
            // Set up the shared UIMenuController
            let saveMenuItem = UIMenuItem(title: "Save", action: #selector(saveTapped))
            let deleteMenuItem = UIMenuItem(title: "Delete", action: #selector(deleteTapped))
            let copyMenuItem = UIMenuItem(title: "Copy", action: #selector(copyTapped))
            
            UIMenuController.shared.menuItems = [saveMenuItem, deleteMenuItem, copyMenuItem]
            
            let size = UIMenuController.shared.menuFrame.size;
            var menuFrame = CGRect(x: 200, y: 200, width: 100, height: 100)
            menuFrame.origin.x = self.tableView.frame.origin.x;
            menuFrame.origin.y = pnt.y
            menuFrame.size = size;
            
            // Tell the menu controller the first responder's frame and its super view
            UIMenuController.shared.setTargetRect(menuFrame, in: self.tableView)
            
            // Animate the menu onto view
            UIMenuController.shared.setMenuVisible(true, animated: true)
        }
    }
    
    @objc func saveTapped() {
        print("save tapped")
        responsiveView.resignFirstResponder()
    }
    
    @objc func deleteTapped() {
        print("delete tapped")
        responsiveView.resignFirstResponder()
    }
    @objc func copyTapped() {
        print("copy tapped")
        responsiveView.resignFirstResponder()
    }
    
    //MARK:- UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as UITableViewCell
        cell.textLabel?.text = "Cell \(indexPath.row)"
        return cell
    }
    
}

