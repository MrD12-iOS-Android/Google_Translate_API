//
//  SelectLanguages.swift
//  HomeWork_72_Google_Translate_API
//
//  Created by Oybek Iskandarov on 6/18/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
struct Posts : Codable{
    var lang : String
}

protocol Send {
    func didsendS(source: String?)
    func didsendT(target: String?)
}

class SelectLanguages: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var datas = [Posts]()
    var del1 : Send!
    var del2 : Send!
    var bools = false
    @IBOutlet weak var table: UITableView!{
        didSet{
            table.delegate = self
            table.dataSource = self
            table.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let loading = NVActivityIndicatorView(frame: .zero, type: .ballTrianglePath, color: .red, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 80),
            loading.heightAnchor.constraint(equalToConstant: 80),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        loading.startAnimating()
        
        let url = "https://google-translate1.p.rapidapi.com/language/translate/v2/languages"
        let headers : HTTPHeaders = [
            "accept-encoding": "application/gzip",
            "x-rapidapi-key": "616cf0babemshee25556e718792fp19501ejsn5aa88cfd8bac",
            "x-rapidapi-host": "google-translate1.p.rapidapi.com"
        ]

        AF.request(url, method: .get, headers: headers).responseJSON { (res) in
            loading.stopAnimating()
            if let data = res.data{
                let json = JSON(data)
                for i in 0..<json["data"]["languages"].count{
                    let rrr = json["data"]["languages"][i]
                    let www = Posts(lang: rrr["language"].stringValue.uppercased())
                    self.datas.append(www)
                }
            }
            self.table.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.langLabel.text = datas[indexPath.row].lang
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if bools{
            del1.didsendT(target: datas[indexPath.row].lang)
        }else{
            del2.didsendS(source: datas[indexPath.row].lang)
        }
        dismiss(animated: true, completion: nil)
    }
}
