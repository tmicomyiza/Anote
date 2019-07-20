//
//  ViewController.swift
//  Anote
//
//  Created by Theogene Micomyiza on 7/18/19.
//  Copyright © 2019 Theogene Micomyiza. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    
    //table view outlet
    @IBOutlet weak var table: UITableView!
    
    //array of elements to be displayed on the table view
    var data: [String] = []
    
    //property to track selected row
    var selectedRow: Int = -1
    
    //keeps track of changes that take place in DetailViewController
    var NewRowText: String = ""
    
    //save data on a file
    var fileURL: URL!
    
    
    
    //returns an Int representing number of items in data array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    //populate table with elements from array name data
    //returns a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = data[indexPath.row]
        
        return cell
    }
    
    
    //action to set the table into editing mode
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
    }
    
    
    
    
    //delete content on table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //deletes item from the array
        data.remove(at: indexPath.row)
        
        //deletes row from the table
        table.deleteRows(at: [indexPath], with: .fade)
        
        //save changes
        save()
        
    }
    
    
    //handle the row that was selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //this method will perfom segue when a row is selected on the screen
        self.performSegue(withIdentifier: "detail", sender: nil)
        
    }
    
    
    
    //facilitate to send data from ViewController to DetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView: DetailViewController = segue.destination as! DetailViewController
        
        //keep track of the selected row
        selectedRow = table.indexPathForSelectedRow! .row
        
        //define master view so that it doesn't crash in DetailViewController
        detailView.masterView = self
        
        //send info of selected row to DetailViewController
        detailView.setText(info: data[selectedRow])
    }
    
    
    //store our data
    func save ()   {
        
        //to persistent storage
       /* UserDefaults.standard.set(data, forKey: "notes")*/
        
        //write to the file instead of persistent storage
        let temp = NSArray(array: data)
        
        do {
            try temp.write(to: fileURL)
        } catch  {
            print("error handling file")
        }
    }
    
    
    //method to load data from memory
    func load()   {
        
        //check if there is data to load from persistent storage
        /*if let loadedData : [String] = UserDefaults.standard.value(forKey: "notes") as? [String] {
            data = loadedData
            table.reloadData()
        }*/
        
        if let loadedData : [String] = NSArray(contentsOf: fileURL) as? [String] {
            data = loadedData
            table.reloadData()
        }
        
    }
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //initialize table to this instance of the class
        table.dataSource = self
        table.delegate = self
        
        //set title
        self.title = "Notes"
        
        //make title bigger
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        //add button on the navigation bar
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addnote))
        
        //button to allow user to add content
        self.navigationItem.rightBarButtonItem = addButton
        
        //button to allow user to edit content
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        
        //get URL to the file that will contain our data
        
        //for: the file will be saved in docoment directory
        //ini: document directory is on the device of the user
        //appropriateFor :
        //create: in case destination doesn't exist, one will be created
        //try! : will handle throws cases
        let baseURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        fileURL = baseURL.appendingPathComponent("notes.txt")
        //call load function
        load()
    }
    
    
    //will run after the user select back from DetailViewController
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //check if there is a row that was selected
        //this method will not do anything when the App is initiated and user hasn't selected a row
        //or decided to add a new element
        
        // -1 is the default value of selectedRow
        if selectedRow  == -1 {
            return
        }
        
        
        //since there is a selectedRow, then we need to act in that case
        //in case the user deletes every content of the row, we do not need to add it to data
        
        data[selectedRow] = NewRowText
        
        if NewRowText == "" {
            data.remove(at: selectedRow)
        }
        
        //relaod the table to update all informatio on the screen
        table.reloadData()
        
        //then save data
        save()
    }
    
    
    
    //method to add a new item
    @objc func addnote () {
        //check whether the table is in editing mode.
        //If true, then disable add button.
        if table.isEditing {
            return
        }
        
        //start with empty string whenever new row is added
        let name = ""
        
        //add a new item on the front of the array
        data.insert(name, at: 0)
        
        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        
        table.insertRows(at: [indexPath], with: .automatic)
        
        //save
        //save()
       
        //generate a row in order to transition to the next view controller
        //this will prevent the app to crash when addnote button is selected
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        //this method will perfom segue when a row is selected on the screen
        self.performSegue(withIdentifier: "detail", sender: nil)
    }

}

