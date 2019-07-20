//
//  DetailViewController.swift
//  Anote
//
//  Created by Theogene Micomyiza on 7/19/19.
//  Copyright © 2019 Theogene Micomyiza. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    //view controller
    @IBOutlet weak var textView: UITextView!
    
    //stores info added on DetailViewController
    var text : String = ""
    
    //it is unwrapped because everyone it is called it must be defined
    //it is defined in ViewController under method named "prepare" which has two parameters with keywords "for segue" and "sender"
    var masterView: ViewController!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //we modifiy the text after the view is loaded when segue is initiated
        textView.text = text
        
        //set title size to small in DetailViewController mode
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    
    
    //triggers keyboard whenever user opens a row
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //show software keyboard
        textView.becomeFirstResponder()
    }
    
    
    //send data back to ViewController from DetailViewController
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        masterView.NewRowText = textView.text
        
        //hide software keyboard
        textView.resignFirstResponder()
    }
    
    //Purpose: set up an option for setting text from main view controller
    func setText (info: String) {
        text = info
        
        if isViewLoaded {
            textView.text = info
        }
    }
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
