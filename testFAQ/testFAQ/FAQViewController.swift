//
//  ViewController.swift
//  Demo-iOS
//
//  Created by Mukesh Thawani on 13/11/16.
//  Copyright © 2016 Mukesh Thawani. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)


class FAQViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    private let kBookCellIdentifier: String = "ExpandCellIdentifier"

    
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    var arrFAQDate:NSMutableArray = NSMutableArray()
  //  var faqArray:NSMutableArray = NSMutableArray()
    var faqDescription:NSDictionary = NSDictionary()
    var expandedIndexPaths:NSMutableSet = NSMutableSet()

    var arrloginData:NSDictionary = NSDictionary()
    var user_id : NSString = NSString()
    var session_key : NSString = NSString()
    var user_type : NSString = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ////////////////////////
        
        let cellNib = UINib(nibName: NSStringFromClass(FAQ_TVCell.self), bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: kBookCellIdentifier)
        expandedIndexPaths = NSMutableSet()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        title = "FAQ View"

        faqDescription = ["What is reddit?": "1111111", "22222What is reddit?": "cddfg dfgdfge"] // dict is of type Dictionary<Int, String>

        //setupFAQ(withDictinary: faqDescription as! [AnyHashable : Any])
        
      //  setupFAQ(withDictinary: faqDescription)
        
        
        
        ////////////////////////
        //1 English 0 Arabic
        let selectedLanguage = UserDefaults.standard.object(forKey: "selectedLanguage") as! String!
        if selectedLanguage == "1" {
            self.viewTitle.transform = CGAffineTransform(scaleX: 1, y: 1)
            lblTitle.textAlignment=NSTextAlignment.left
            
        }
        else
        {
            self.viewTitle.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.lblTitle.transform = CGAffineTransform(scaleX: -1, y: 1)
            lblTitle.textAlignment=NSTextAlignment.right
            
        }
        
        self.title = "FAQs"
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: nil, action: nil)
        navigationItem.leftBarButtonItem = rightBarButton
        self.automaticallyAdjustsScrollViewInsets = false
        
        tableView.reloadData()
        CallWebService_faq()
    }
    
    
    @IBAction func btnBack(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: FAQ Model Setup with Dictiinary Method
  /*  func setupFAQ(withDictinary dictnary: NSDictionary)
    {
        var allQuestions: NSArray = NSArray()//dictnary.keys
        allQuestions=dictnary.allKeys as NSArray
        faqArray=NSMutableArray()
        for question in allQuestions {
            let objFaq = FAQItem()
            objFaq.question = question as! String as NSString!
            objFaq.answer = dictnary.value(forKey: question as! String) as! NSString!
            faqArray.add(objFaq)
        }
        
    }*/

    
    //MARK: tableView
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrFAQDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
      /*  var cell: FAQ_TVCell? = (tableView.dequeueReusableCell(withIdentifier: kBookCellIdentifier) as? Any as! FAQ_TVCell?)
        var objFaq: FAQ_TVCell? = (faqArray[indexPath.row] as? FAQItem)
        cell?.titleLabel?.text = objFaq?.question
        cell?.descriptionLabel?.text = objFaq?.answer
        //cell.imageIcon.image = [UIImage imageNamed:@"expandGlyph"];
        cell?.withDetails = expandedIndexPaths.contains(indexPath)
        return cell*/
       
        
        let identifier = "FAQ_TVCell"
        var cell: FAQ_TVCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? FAQ_TVCell
        if cell == nil
        {
            tableView.register(UINib(nibName: "FAQ_TVCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? FAQ_TVCell
        }

        cell?.titleLabel?.text = (((self.arrFAQDate[indexPath.row] as AnyObject).value(forKey: "question")) as! String)
        cell?.descriptionLabel?.text = (((self.arrFAQDate[indexPath.row] as AnyObject).value(forKey: "answer")) as! String)
        //cell.imageIcon.image = UIImage(named: "IQButtonBarArrowLeft@2x.png")
        cell?.WithDetails = expandedIndexPaths.contains(indexPath)

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
      
      //  let indexPath = tableView.indexPathForSelectedRow
      //  let currentCell = tableView.cellForRow(at: indexPath!) as! FAQ_TVCell!

        if expandedIndexPaths.contains(indexPath) {
            let cell: FAQ_TVCell? = (tableView.cellForRow(at: indexPath) as! FAQ_TVCell?)
            cell?.animateClosed()
            expandedIndexPaths.remove(expandedIndexPaths.index(ofAccessibilityElement: indexPath))
            tableView.reloadRows(at: [indexPath], with:.none)
        }
        else {
            
            if Array(expandedIndexPaths).count > 0 {
                let removeExisting: IndexPath? = self.expandedIndexPaths.allObjects[0] as? IndexPath//Array(expandedIndexPaths)[0]
                var cell: FAQ_TVCell? = (tableView.cellForRow(at: removeExisting!) as! FAQ_TVCell?)
                cell?.animateClosed()
                expandedIndexPaths.remove(expandedIndexPaths.index(ofAccessibilityElement: removeExisting!))
                tableView.reloadRows(at: [removeExisting!], with: .none)
                expandedIndexPaths.add(indexPath)
                tableView.reloadRows(at: [indexPath], with: .none)
                cell = (tableView.cellForRow(at: indexPath) as! FAQ_TVCell?)
                cell?.animateOpen()
            }
            else {
                expandedIndexPaths.add(indexPath)
                tableView.reloadRows(at: [indexPath], with: .none)
                let cell: FAQ_TVCell? = (tableView.cellForRow(at: indexPath) as! FAQ_TVCell?)
                cell?.animateOpen()
            }
        }
        
        
    }
    
    
    
    
    //MARK: - API calling
    func createBodyWithParameters(_ parameters: [String: String]?, boundary: String) -> Data {
        let body = NSMutableData();
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        body.appendString("--\(boundary)--\r\n")
        return body as Data
    }
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func CallWebService_faq()
    {
        
        if UserDefaults.standard.dictionary(forKey: "arrloginData") !=  nil {
            arrloginData = UserDefaults.standard.dictionary(forKey: "arrloginData")! as NSDictionary
            user_id = String(format: "%@", arrloginData .value(forKey: "user_id") as! CVarArg) as NSString
            session_key = String(format: "%@", arrloginData .value(forKey: "session_key")as! String) as NSString
            user_type = String(format: "%@", arrloginData .value(forKey: "user_type")as! String) as NSString
        }
        
        
        let strSubUrl: String="http://saree3.net/saree3/index.php/contractor/faq"
        let url = strSubUrl
        
        var request = URLRequest(url:URL(string: url)!)
        request.httpMethod = "POST";
        
        var device_token:String!
        if UserDefaults.standard.object(forKey: "DeviceToken") != nil {
            device_token = UserDefaults.standard.object(forKey: "DeviceToken")as! String
            print("DeviceToken....\(device_token!)")
        } else {
            device_token = ""
        }
        
        /*
         device_id
         session_key
         user_id
         */
        
        let params12 =
            [
                "user_id"       :"75",//"\(user_id)",
                "device_id"     :"8A53BAC7-82A4-45F8-A321-57A1B0943599",//"\(device_token!)",
                "session_key"   :"Hrs5WkX7G7e73Sk9"//"\(session_key)",
        ]
        
        print("params12....\(params12)")
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBodyWithParameters(params12, boundary: boundary)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data content = \(responseString!)")
            do
            {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                if let Dictionar = json as? NSDictionary
                {
                    print("wenservice POST response >>> \(Dictionar)")
                    let message=Dictionar["message"] as? NSString
                    
                    if message=="success"
                    {
                        DispatchQueue.main.async(execute: {
                            self.arrFAQDate=(Dictionar["faq"] as? NSArray)?.mutableCopy() as! NSMutableArray
                            print("self.arrFAQDate....\(self.arrFAQDate)")
                            print("arrFAQDate.count....\(self.arrFAQDate.count)")
                            
                            for i in 0..<self.arrFAQDate.count
                            {
                                let question = (self.arrFAQDate[i]as! NSDictionary).object(forKey: "question")as! String
                                let answer = (self.arrFAQDate[i]as! NSDictionary).object(forKey: "answer")as! String
                                
                                print("question...\(question)")
                                print("answer...\(answer)")
                                
                                
                            }
                            self.tableView.reloadData()
                            
                            
                        })
                    }
                    else
                    {
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            self.tableView.reloadData()
                            
                        })
                    }
                }
            }
            catch
            {
                print(error)
            }
        })
        task.resume()
    }
    
    
    
}


extension NSMutableData {
    func appendString(_ string: String){
        let data = string.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: true)
        append(data!)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}



