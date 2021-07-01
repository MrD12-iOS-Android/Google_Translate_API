//
//  Main.swift
//  HomeWork_72_Google_Translate_API
//
//  Created by Oybek Iskandarov on 6/18/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class Main: UIViewController {

    @IBOutlet weak var mic: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var backTransView: UIView!
    @IBOutlet weak var bTestLblb: UILabel!
    @IBOutlet weak var aTestlbl: UILabel!
    @IBOutlet weak var exchangeBtn: UIButton!
    @IBOutlet weak var bselectLang: UIButton!
    @IBOutlet weak var aselectLang: UIButton!
    @IBOutlet weak var aTF: UITextView!
    @IBOutlet weak var bTF: UITextView!
    var bool = true
    var sourceText = "en"
    var targetText = "uz"
    override func viewDidLoad() {
        super.viewDidLoad()
        mic.layer.cornerRadius = mic.frame.height / 2
        backTransView.layer.cornerRadius = 10

        aTF.layer.cornerRadius = 10
        bTF.layer.cornerRadius = 10
        
        bottomView.layer.cornerRadius = 30
        aselectLang.layer.cornerRadius = 10
        bselectLang.layer.cornerRadius = 10
        
        aTF.delegate = self
        bTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        aselectLang.layer.shadowColor = UIColor.green.cgColor
        aselectLang.layer.shadowRadius = 8
        aselectLang.layer.shadowOpacity = 0.7
        bselectLang.layer.shadowColor = UIColor.green.cgColor
        bselectLang.layer.shadowRadius = 8
        bselectLang.layer.shadowOpacity = 0.7
        
        backTransView.layer.shadowColor = UIColor.green.cgColor
        backTransView.layer.shadowRadius = 10
        backTransView.layer.shadowOffset = CGSize(width: 1, height: 1)
        backTransView.layer.shadowOpacity = 0.2
        
        mic.layer.shadowColor = UIColor.orange.cgColor
        mic.layer.shadowRadius = 10
        mic.layer.shadowOpacity = 0.5
        bottomView.layer.shadowColor = UIColor.orange.cgColor
        bottomView.layer.shadowRadius = 10
        bottomView.layer.shadowOpacity = 0.4
        
        if targetText == sourceText{
            aTF.text = "ERROR"
            bTF.text = "ERROR"
        }
        aTestlbl.text = sourceText
        bTestLblb.text = targetText
    }
    @IBAction func aBtnSelect(_ sender: Any) {
        let vc = SelectLanguages(nibName: "SelectLanguages", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        vc.del2 = self
        vc.bools = false
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func bBtnSelect(_ sender: Any) {
        let vc = SelectLanguages(nibName: "SelectLanguages", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        vc.del1 = self
        vc.bools = true
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true, completion: nil)
    }

    
    @IBAction func exchangeLang(_ sender: Any) {
        if bool{
            aTestlbl.text = targetText
            bTestLblb.text = sourceText
        }else{
            aTestlbl.text = sourceText
            bTestLblb.text = targetText
        }
        bool = !bool
    }
    func translate(){
        let url = "https://google-translate1.p.rapidapi.com/language/translate/v2"
        let texta = aTF.text!
        let textb = bTF.text!
        let headers : HTTPHeaders = [
            "content-type": "application/x-www-form-urlencoded",
                "accept-encoding": "application/gzip",
                "x-rapidapi-key": "616cf0babemshee25556e718792fp19501ejsn5aa88cfd8bac",
                "x-rapidapi-host": "google-translate1.p.rapidapi.com"
        ]
        if bool{
                   let params = [
                       "q" : texta,
                       "target" : targetText,
                       "source" : sourceText
                   ]
            AF.request(url, method: .post, parameters: params,  headers: headers).responseJSON { response in
                guard let data = response.data else { return }
                let json = JSON(data)
                print(json)
               
                let translations = json["data"]["translations"]
                let t = translations[0]["translatedText"].stringValue
                
                self.bTF.text = t
                self.bTF.textColor = .green
                self.aTF.textColor = .red
            }
        }else{
            let params = [
                "q" : textb,
                "target" : targetText,
                "source" : sourceText
            ]
     AF.request(url, method: .post, parameters: params,  headers: headers).responseJSON { response in
                 guard let data = response.data else { return }
                 let json = JSON(data)
                 let translations = json["data"]["translations"]
                 let t = translations[0]["translatedText"].stringValue
                 self.aTF.text = t
                 self.aTF.textColor = .green
                 self.bTF.textColor = .red
            }
        }
    }
}
extension Main : UITextViewDelegate{
    func textViewDidChangeSelection(_ textView: UITextView) {
        translate()
        backTransView.layer.shadowOpacity = 0.7
        aselectLang.layer.shadowOpacity = 0.2
        bselectLang.layer.shadowOpacity = 0.2
        aselectLang.layer.shadowColor = UIColor.red.cgColor
        bselectLang.layer.shadowColor = UIColor.red.cgColor
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if aTF.text.isEmpty || bTF.text.isEmpty{
            backTransView.layer.shadowOpacity = 0.2
            aselectLang.layer.shadowOpacity = 0.7
            bselectLang.layer.shadowOpacity = 0.7
            aselectLang.layer.shadowColor = UIColor.green.cgColor
            bselectLang.layer.shadowColor = UIColor.green.cgColor
        }
    }
}
extension Main : Send{
    func didsendS(source: String?) {
        aselectLang.setTitle(source, for: .normal)
        sourceText = source!.lowercased()
        aTestlbl.text = source
    }
    
    func didsendT(target: String?) {
        bselectLang.setTitle(target, for: .normal)
        targetText = target!.lowercased()
        bTestLblb.text = target
    }
}
