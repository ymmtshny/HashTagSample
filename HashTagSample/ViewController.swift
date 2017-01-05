//
//  ViewController.swift
//  HashTagSample
//
//  Created by Shinya Yamamoto on 2017/01/05.
//  Copyright © 2017年 shinyayamamoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textView.resolveHashTags()
        textView.isSelectable = true
        textView.isEditable = false
        textView.delegate = self
        textView.dataDetectorTypes = .all
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 10.0, *)
     func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let str = URL.absoluteString.removingPercentEncoding {
            let alert = UIAlertController.singleBtnAlertWithTitle("押したよ！", message: str, action: {})
            self.present(alert, animated: true, completion: {})
        }
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let alert = UIAlertController.singleBtnAlertWithTitle("押したよ！", message: URL.absoluteString, action: {})
        self.present(alert, animated: true, completion: {})
        return false
    }

}

//http://stackoverflow.com/questions/34294064/how-to-make-uitextview-detect-hashtags
extension UITextView {
    
    func resolveHashTags(){
        
        // turn string in to NSString
        let nsText:NSString = self.text as NSString
        
        // this needs to be an array of NSString.  String does not work.
        let words:[String] = nsText.components(separatedBy: " ")
        
        // you can't set the font size in the storyboard anymore, since it gets overridden here.
        let attrs = [
            NSFontAttributeName : UIFont.systemFont(ofSize: 14)
        ]
        
        // you can staple URLs onto attributed strings
        let attrString = NSMutableAttributedString(string: nsText as String, attributes:attrs)
        
        // tag each word if it has a hashtag
        for word in words {
            
            // found a word that is prepended by a hashtag!
            // homework for you: implement @mentions here too.
            if word.hasPrefix("#") {
                
                // a range is the character position, followed by how many characters are in the word.
                // we need this because we staple the "href" to this range.
                let matchRange:NSRange = nsText.range(of: word as String)
                
                // convert the word from NSString to String
                // this allows us to call "dropFirst" to remove the hashtag
                var stringifiedWord:String = word as String
                
                // drop the hashtag
                stringifiedWord = String(stringifiedWord.characters.dropFirst())
                
    
                if let stringURL =  "hash:\(stringifiedWord)".addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
                    if let url = NSURL(string: stringURL) {
                        attrString.addAttribute(NSLinkAttributeName, value:url , range: matchRange)
                    }
                }

            }
        }
        
        // we're used to textView.text
        // but here we use textView.attributedText
        // again, this will also wipe out any fonts and colors from the storyboard,
        // so remember to re-add them in the attrs dictionary above
        self.attributedText = attrString
    }
    
}

extension UIAlertController {
    
    class func singleBtnAlertWithTitle(_ title: String,
                                       message: String,
                                       action: (() -> Void)) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            if let completion = action {
                completion
            }
        }))
        
        return alert
    }

}

