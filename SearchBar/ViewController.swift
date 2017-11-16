//
//  ViewController.swift
//  SearchBar
//
//  Created by D7702_10 on 2017. 11. 16..
//  Copyright © 2017년 DoubleK. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    @IBOutlet weak var TableView: UITableView!
    let arrayA = ["ac","ag","be","bu","hy","wt","wa","bs","ef","qw"]
    
    //딕셔너리 생성
    var twiceDic: [String:[String]]!
    var twiceName: [String]!
    
    var searchCon: UISearchController!
    var filteredArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //json 불러오기
        let pathA = Bundle.main.path(forResource: "Twice", ofType: "json")
        let dataA = try! Data(contentsOf: URL(fileURLWithPath: pathA!))
        self.twiceDic = try! JSONSerialization.jsonObject(with: dataA, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String:[String]]
        self.twiceName = Array(twiceDic.keys)
        
        //search 컨트롤러
        self.searchCon = UISearchController(searchResultsController: nil)
        //searchBar 글자가 바뀔때마다 반응
        self.searchCon.searchResultsUpdater = self
        //백그라운드
        self.searchCon.dimsBackgroundDuringPresentation = false
        //사이즈
        self.searchCon.searchBar.sizeToFit()
        //searchBar를 테이블 헤더에 넣기
        self.TableView.tableHeaderView = self.searchCon.searchBar
        
        //cell 생성
        self.TableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        TableView.dataSource = self
        TableView.delegate = self
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.twiceName
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.twiceName.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.searchCon.isActive{
            return filteredArray.count
        } else {
            //return twiceName.count
            let memberName = self.twiceName[section]
            let specArray = self.twiceDic[memberName]
            return specArray!.count

        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.twiceName[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if self.searchCon.isActive{
            cell.textLabel?.text = filteredArray[indexPath.row]
        } else{
            let memberName = self.twiceName[indexPath.section]
            let specArray = self.twiceDic[memberName]
            
            cell.textLabel?.text = specArray![indexPath.row]
        }
        
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //print(searchController.searchBar.text!)
        filteredArray.removeAll(keepingCapacity: false)
        let predicateA = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let arrayF = (arrayA as NSArray).filtered(using: predicateA)
        filteredArray = arrayF as! [String]
        self.TableView.reloadData()
    }
}

