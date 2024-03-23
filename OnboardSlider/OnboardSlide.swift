//
//  StoryboardExampleViewController.swift
//  Voj-Voj
//
//  Created by Zenitus Technologies on 06/12/21.
//

import UIKit
import AVFoundation
import AVKit

class OnboardSlide: UIViewController {
    
    @IBOutlet weak var onboardSlides: SwiftyOnboard!
    
    var avPVC = AVPlayerViewController()
    var player = AVPlayer()
    var playButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardSlides.style = .light
        onboardSlides.delegate = self
        onboardSlides.dataSource = self
        //onboardSlides.backgroundColor = UIColor(red: 46/256, green: 46/256, blue: 76/256, alpha: 1)
        onboardSlides.backgroundColor = .black
        self.view.backgroundColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @objc func handleSkip() {
        self.player.pause()
        onboardSlides?.goToPage(index: 5, animated: true)
    }
    
    @objc func handleContinue(sender: UIButton) {
        self.player.pause()
        let index = sender.tag
        if index != 5 {
            onboardSlides?.goToPage(index: index + 1, animated: true)
        } else {
        }
    }
}

extension OnboardSlide: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return 6
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = CustomPage.instanceFromNib() as? CustomPage
        //view?.backgroundColor = UIColor.convertRGB(hexString: "2B2B2B")
        view?.backgroundColor = UIColor.black
        view?.image.layer.masksToBounds = true
        if index < 5 {
            view?.image.image = UIImage(named: "space\(index).png")
        }
        
        if index == 5 {
            view?.image.isHidden = true
            
            if let filePath = Bundle.main.path(forResource: "vojvoj", ofType: "mp4") {
                self.avPVC.player = nil
                self.player = .init(url: URL(fileURLWithPath: filePath))
                self.avPVC.player = self.player
                self.avPVC.videoGravity = .resizeAspectFill
                self.player.automaticallyWaitsToMinimizeStalling = false
                self.avPVC.view.frame = view!.bounds
                self.avPVC.showsPlaybackControls = false
                view?.insertSubview(self.avPVC.view, at: 0)
                
                playButton.frame = CGRect(x: UIScreen.screenWidth/2 - 25, y: UIScreen.screenHeight/2 - 25, width: 50, height: 50)
                playButton.backgroundColor = .clear
                playButton.setImage(UIImage(systemName: "play.fill")?.withTintColor(.white), for: .normal)
                playButton.layer.cornerRadius = playButton.frame.height/2
                playButton.layer.borderColor = UIColor.white.cgColor
                playButton.layer.borderWidth = 1
                playButton.clipsToBounds = true
                playButton.tintColor = .white
                playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
                self.playButton.isHidden = false
                view?.addSubview(playButton)
                
            }
        }
        /*else if index == 1 {
            view?.image.isHidden = false
        } else if index == 2 {
            view?.image.isHidden = false
        } else {
            view?.image.isHidden = false
        }*/
        return view
    }
    
    @objc func playVideo() {
        self.playButton.isHidden = true
        self.player.play()
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = CustomOverlay.instanceFromNib() as? CustomOverlay
        overlay?.skip.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay?.buttonContinue.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        self.player.pause()
        let overlay = overlay as! CustomOverlay
        let currentPage = round(position)
        overlay.contentControl.currentPage = Int(currentPage)
        overlay.buttonContinue.tag = Int(position)
        
        if currentPage == 5 {
            overlay.buttonContinue.setTitle("Get Started!", for: .normal)
            overlay.skip.isHidden = true
            self.playButton.isHidden = false
        } else if currentPage <= 4.0 {
            overlay.buttonContinue.setTitle("Continue", for: .normal)
            overlay.skip.setTitle("Skip", for: .normal)
            overlay.skip.isHidden = false
        }
        /*else {
            overlay.buttonContinue.setTitle("Get Started!", for: .normal)
            overlay.skip.isHidden = true
        }*/
    }
    
    func setTextWithLineSpacing(label:UILabel,text:String,lineSpacing:CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        attrString.addAttributes([NSAttributedString.Key.backgroundColor: UIColor.init(red: 232/255.0, green: 59/255.0, blue: 174/255.0, alpha: 1.0)], range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
