//
//  NewsFeedVC.swift
//  QuickNet
//
//  Created by DTran on 12/24/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import UIKit
import Hero
import PullToReach
import SwipeableTabBarController
import ViewAnimator
import FontAwesome_swift

var indexSelected: IndexPath!
var updatedString : String!
var layout = 0
var popoverButton = 0
var darkMode = 1
var navTitleName = "News Sources"

class NewsFeedVC: UIViewController, UIPopoverPresentationControllerDelegate, PullToReach {
    

    var scrollView: UIScrollView {
        return collectionView
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layoutButton: UIBarButtonItem!
    @IBOutlet weak var countryButton: UIBarButtonItem!
    @IBOutlet weak var sourcesButton: UIButton!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var categoryButton: UIBarButtonItem!
    
    let button = UIButton(type: UIButton.ButtonType.system) as UIButton
    let label = UILabel()
    let refreshControl = UIRefreshControl()
    let trackLayer = CAShapeLayer()
    let shapeLayer = CAShapeLayer()
    static let instance = NewsFeedVC()
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.scrollsToTop = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        collectionView.alwaysBounceVertical = true
        
        

        
        let timeInterval = 1.0
        collectionView.hero.modifiers = [.scale(1.2), .duration(timeInterval)]
        for cell in collectionView.visibleCells
        {
            cell.hero.modifiers = [.fade, .scale(0.5)]
        }
//        let animations = [AnimationType.from(direction: .top, offset: 30.0)]
//
//        collectionView?.performBatchUpdates({
//            UIView.animate(views: self.collectionView!.orderedVisibleCells, animations: animations, completion: nil)}, completion: nil)
        
        label.hero.modifiers = [.fade, .translate(x: 0, y: -300, z: 0)]
        
        spinner.translatesAutoresizingMaskIntoConstraints = false

        refreshButton.action = #selector(refreshNewsFeedButton)
        countryButton.action = #selector(showCountryButton)
        layoutButton.action = #selector(layoutButtonClicked)
        categoryButton.action = #selector(showCategoryButton)

        navigationItem.title = "News Feed"
        self.navigationItem.rightBarButtonItems = [refreshButton, countryButton]
        self.navigationItem.leftBarButtonItems = [layoutButton, categoryButton]
        self.activatePullToReach(on: navigationItem, highlightColor: UIColor.lightGray.withAlphaComponent(0.45))

        
        NotificationCenter.default.addObserver(self, selector: #selector(setAlpha), name: NSNotification.Name(rawValue: "alpha"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLoader), name: NSNotification.Name(rawValue: "alpha2"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(downloadCompleted), name: NOTIF_DOWNLOAD_COMPLETE, object: nil)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
        longPress.cancelsTouchesInView = false
        longPress.minimumPressDuration = 0.7
        tabBarController?.tabBar.addGestureRecognizer(longPress)
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(NewsFeedVC.doubleTapGesture))
        doubleTap.numberOfTapsRequired = 2
        tabBarController?.tabBar.addGestureRecognizer(doubleTap)
        
        if darkMode == 1{
            enableDarkMode()
        }else{
            disableDarkMode()
        }
        
        createScrollButton()
        createLabel()
        refreshControlSetup()
        setupSourcesButton()
        

        // Do any additional setup after loading the view.
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        updatedString = "\(formatter.string(from: currentDateTime))"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        self.title = "News Feed \n\(updatedString!)"
//        if collectionView.backgroundColor == .black{
//            enableDarkMode()
//        }else{
//            disableDarkMode()
//        }
        for navItem in(self.navigationController?.navigationBar.subviews)! {
            for itemSubView in navItem.subviews {
                if let largeLabel = itemSubView as? UILabel {
                    largeLabel.text = self.title
                    largeLabel.numberOfLines = 0
                    largeLabel.sizeToFit()
                    largeLabel.lineBreakMode = .byCharWrapping
                }
            }
        }
        createLoader()
        
    }
    @objc func doubleTapGesture(){
        if tabBarController?.selectedIndex == 0{
            let indexpath = IndexPath(row: 0, section: 0)
            collectionView.scrollToItem(at: indexpath, at: .top, animated: true)
        }
        
        
    }
    
    func refreshControlSetup(){
        refreshControl.addTarget(self, action: #selector(refreshNewsFeed(_:)), for: .valueChanged)
        let refreshString = "Fetching Latest News Articles"
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string: refreshString, attributes: attributes)
        refreshControl.tintColor = .white
        //        collectionView.refreshControl = refreshControl
    }
    func setupSourcesButton(){
        sourcesButton.frame = CGRect(x: 100, y: 7, width: 200, height: 30)
        sourcesButton.titleLabel?.lineBreakMode = .byTruncatingTail
        sourcesButton.titleLabel?.numberOfLines = 2
        sourcesButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 14, style: .solid)
        let navTitle = NSMutableAttributedString(string: "\(navTitleName) ", attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold), NSAttributedString.Key.foregroundColor: collectionView.backgroundColor?.isDarkColor == true ? UIColor.white.cgColor : UIColor.black.cgColor])
        
        navTitle.append(NSMutableAttributedString(string: "\(String.fontAwesomeIcon(name: .chevronDown)) ", attributes:[NSAttributedString.Key.font: UIFont.fontAwesome(ofSize: 12, style: .solid), NSAttributedString.Key.foregroundColor: UIColor.gray.cgColor]))
        sourcesButton.setAttributedTitle(navTitle, for: .normal)
        sourcesButton.target(forAction: #selector(showSourcesButton), withSender: nil)
    }
    
    func createLabel(){
        
        let labelXPostion:CGFloat = view.bounds.width / 2 - 115
        let labelYPostion:CGFloat = 180
        let labelWidth:CGFloat = 230
        let labelHeight:CGFloat = 25
        
        
        label.frame = CGRect(x: labelXPostion, y: labelYPostion, width: labelWidth, height: labelHeight)
        label.text = "Fetching Latest News Articles"
        label.textColor = .gray
        label.backgroundColor = .clear
    }
    
    func createScrollButton(){
        let xPostion:CGFloat = view.bounds.width / 2 - 50
        let yPostion:CGFloat = view.bounds.height - 48
        let buttonWidth:CGFloat = 100
        let buttonHeight:CGFloat = 25
        
        
        button.frame = CGRect(x:xPostion, y:yPostion, width:buttonWidth, height:buttonHeight)
        button.layer.cornerRadius = 12
        button.backgroundColor = .white
        button.setTitle("Scroll to Top", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.alpha = 0.7
        button.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
    }
    

    @objc func changeLoader(){
        createLoader()
    }

    
    func createLoader(){

        let circularPath = UIBezierPath(arcCenter: view.center, radius: 30, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.gray.cgColor
        trackLayer.lineWidth = 2
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.path = circularPath.cgPath
        if darkMode == 1{
            shapeLayer.strokeColor = UIColor.white.cgColor
        }else if darkMode == 0{
            shapeLayer.strokeColor = UIColor.black.cgColor
        }
        
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0

    }
    
    func enableDarkMode(){
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.backgroundColor = .clear
        view.backgroundColor = .black
        refreshButton.tintColor = navigationController?.navigationBar.backgroundColor?.isDarkColor == true ? .white : .black
        layoutButton.tintColor = navigationController?.navigationBar.backgroundColor?.isDarkColor == true ? .white : .black
        countryButton.tintColor = navigationController?.navigationBar.backgroundColor?.isDarkColor == true ? .white : .black
        categoryButton.tintColor = .white
        let navTitle = NSMutableAttributedString(string: "\(navTitleName) ", attributes:[
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold), NSAttributedString.Key.foregroundColor: UIColor.white.cgColor])
        navTitle.append(NSMutableAttributedString(string: "\(String.fontAwesomeIcon(name: .chevronDown)) ", attributes:[NSAttributedString.Key.font: UIFont.fontAwesome(ofSize: 12, style: .solid), NSAttributedString.Key.foregroundColor: UIColor.gray.cgColor]))
        sourcesButton.setAttributedTitle(navTitle, for: .normal)
        collectionView.backgroundColor = .black
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .heavy)
        ]
        tabBarController?.tabBar.barTintColor = .black
        tabBarController?.tabBar.tintColor = .white
        spinner.color = .white
    }
    
    
    func disableDarkMode(){
        collectionView.backgroundColor = .white
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.barStyle = .default
        let navTitle = NSMutableAttributedString(string: "\(navTitleName) ", attributes:[
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold), NSAttributedString.Key.foregroundColor: UIColor.black.cgColor])
        navTitle.append(NSMutableAttributedString(string: "\(String.fontAwesomeIcon(name: .chevronDown)) ", attributes:[NSAttributedString.Key.font: UIFont.fontAwesome(ofSize: 12, style: .solid), NSAttributedString.Key.foregroundColor: UIColor.gray.cgColor]))
        sourcesButton.setAttributedTitle(navTitle, for: .normal)
        refreshButton.tintColor = navigationController?.navigationBar.backgroundColor?.isDarkColor == true ? .black : .white
        layoutButton.tintColor = navigationController?.navigationBar.backgroundColor?.isDarkColor == true ? .black : .white
        countryButton.tintColor = navigationController?.navigationBar.backgroundColor?.isDarkColor == true ? .black : .white
        categoryButton.tintColor = .black
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .heavy)
        ]
        tabBarController?.tabBar.barTintColor = .white
        tabBarController?.tabBar.backgroundColor = .clear
        tabBarController?.tabBar.tintColor = .black
        spinner.color = .black
        
    }
    
    
    @objc func longPressAction(_ sender : UILongPressGestureRecognizer) {
        if sender.state == .began{
  
            if collectionView.backgroundColor == .black{
                UserDefaults.standard.set(0, forKey: "darkMode")
                darkMode = 0
                postNotification()
                disableDarkMode()
            }else{
                UserDefaults.standard.set(1, forKey: "darkMode")
                darkMode = 1
                postNotification()
                enableDarkMode()
            }
        }
    }
    
    
    func postNotification(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "alpha2"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func showCategoryButton(){
        showCategoryPopoverClicked((Any).self)
    }

    
    @objc func showCountryButton(){
        showCountryPopoverClicked((Any).self)
    }
    
    @objc func showSourcesButton(){
        showPopoverButtonClicked((Any).self)
    }
    
    
    @IBAction func showCategoryPopoverClicked(_ sender: Any) {
        popoverButton = 3
        
        //Configure the presentation controller
        let popoverContentController = self.storyboard?.instantiateViewController(withIdentifier: "PopoverContentController") as? PopoverContentController
        popoverContentController?.modalPresentationStyle = .popover
        popoverContentController?.preferredContentSize = CGSize(width: 155, height: 255)
        
        /* 3 */
        if let popoverPresentationController = popoverContentController?.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
//            popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            popoverPresentationController.sourceView = self.sourcesButton
            popoverPresentationController.sourceRect = sourcesButton.frame
            popoverPresentationController.backgroundColor = .clear
            popoverPresentationController.delegate = self
            
            popoverContentController?.delegate = self as PopoverContentControllerDelegate
            if let popoverController = popoverContentController {
                present(popoverController, animated: true, completion: nil)
                
                
            }
        }
    }
    
    

    
    
    @IBAction func showCountryPopoverClicked(_ sender: Any) {
        popoverButton = 1
        //Configure the presentation controller
        let popoverContentController = self.storyboard?.instantiateViewController(withIdentifier: "PopoverContentController") as? PopoverContentController
        popoverContentController?.modalPresentationStyle = .popover
        popoverContentController?.preferredContentSize = CGSize(width: 155, height: 300)
    
        /* 3 */
        if let popoverPresentationController = popoverContentController?.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
//            popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            popoverPresentationController.sourceView = self.sourcesButton
            popoverPresentationController.sourceRect = sourcesButton.frame
            popoverPresentationController.backgroundColor = .clear
            popoverPresentationController.delegate = self
            
            popoverContentController?.delegate = self as PopoverContentControllerDelegate
            if let popoverController = popoverContentController {
                present(popoverController, animated: true, completion: nil)
                
                
            }
        }
    }
    
    @IBAction func showPopoverButtonClicked(_ sender: Any) {
        popoverButton = 2
        //Configure the presentation controller
        let popoverContentController = self.storyboard?.instantiateViewController(withIdentifier: "PopoverContentController") as? PopoverContentController
        popoverContentController?.modalPresentationStyle = .popover
        popoverContentController?.preferredContentSize = CGSize(width: 250, height: 500)
        
        /* 3 */
        if let popoverPresentationController = popoverContentController?.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
//            popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            popoverPresentationController.sourceView = self.sourcesButton
            popoverPresentationController.sourceRect = sourcesButton.frame
            popoverPresentationController.delegate = self
            popoverPresentationController.backgroundColor = .clear
            popoverContentController?.delegate = self as PopoverContentControllerDelegate
            if let popoverController = popoverContentController {
                
                present(popoverController, animated: true, completion: nil)
                
                
            }
        }
    }
    
    //UIPopoverPresentationControllerDelegate inherits from UIAdaptivePresentationControllerDelegate, we will use this method to define the presentation style for popover presentation controller
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        setAlphaOfBackgroundViews(alpha: 1)
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        setAlphaOfBackgroundViews(alpha: 0.4)
    }
    
    @objc func setAlpha(){
        setAlphaOfBackgroundViews(alpha: 1.0)
    }

    func setAlphaOfBackgroundViews(alpha: CGFloat) {
            UIView.animate(withDuration: 0.2) {
            self.view.alpha = alpha
            self.navigationController?.navigationBar.alpha = alpha
            
        }
    }

    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        
        refreshNewsFeed((Any).self)
        refreshButton.isEnabled = false
        label.isHidden = false
//        view.addSubview(label)
        collectionView.isHidden = true
    }
    
    
    @objc private func refreshNewsFeed(_ sender: Any) {
        view.layer.addSublayer(trackLayer)
        view.layer.addSublayer(shapeLayer)
        animateLoader()
//        spinner.startAnimating()
//        view.addSubview(spinner)
//
//        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.downloadNewsArticles()
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(stopRefreshing), userInfo: nil, repeats: false)
        
    }
    
    @objc private func refreshNewsFeedButton() {
        refreshButtonClicked((Any).self)
        
    }
    
    func animateLoader(){
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.toValue = 1
        anim.duration = 2
        
        anim.fillMode = CAMediaTimingFillMode.forwards
        anim.isRemovedOnCompletion = false
        shapeLayer.add(anim, forKey: "animation")
    
    }
    
    @objc func stopRefreshing(){
        trackLayer.removeFromSuperlayer()
        shapeLayer.removeFromSuperlayer()
//        spinner.stopAnimating()
//        spinner.removeFromSuperview()
        collectionView.isHidden = false
        label.isHidden = true
        collectionView.reloadData()
        self.refreshControl.endRefreshing()
        refreshButton.isEnabled = true
        let indepath = IndexPath(row: 0, section: 0)
        if  NewsService.instance.newsList.count > 0{
            collectionView.scrollToItem(at: indepath, at: .top, animated: true)
        }

        
    }
    @objc func buttonAction(_ sender:UIButton!)
    {
        let indexpath = IndexPath(row: 0, section: 0)
        collectionView.scrollToItem(at: indexpath, at: .top, animated: true)
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(showTab), userInfo: nil, repeats: false)
        
    }
    
    @objc func showTab(){
        self.button.isHidden = true
        changeTabBar(hidden: false, animated: true)
        
    }
    @objc func layoutButtonClicked(){
        changeLayout((Any).self)
    }
    
    @IBAction func changeLayout(_ sender: Any) {
        if layout == 0
        {
            layout = 1
            navigationItem.leftBarButtonItem?.image = UIImage(named: "grid")
            collectionView.reloadData()
        }else{
            layout = 0
            navigationItem.leftBarButtonItem?.image = UIImage(named: "list")
            collectionView.reloadData()
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
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let anim : CABasicAnimation = CABasicAnimation.init(keyPath: "transform")
        anim.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        anim.duration = 0.8
        anim.repeatCount = 2
        anim.autoreverses = true
        anim.isRemovedOnCompletion = true
        anim.toValue = NSValue.init(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.3))
        button.layer.add(anim, forKey: nil)

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0{
            self.view.addSubview(button)
            self.button.isHidden = false

            changeTabBar(hidden: true, animated: true)
        }
        else{
            self.button.isHidden = true
            changeTabBar(hidden: false, animated: true)
        }
    }
    
    
    func changeTabBar(hidden:Bool, animated: Bool){
        guard let tabBar = self.tabBarController?.tabBar else { return; }
        if tabBar.isHidden == hidden{ return }
        let duration:TimeInterval = (animated ? 0.5 : 0.0)
        tabBar.isHidden = false
        
        UIView.animate(withDuration: duration, animations: {
        }, completion: { (true) in
            tabBar.isHidden = hidden
        })
    }
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailNewsSegue"{
            if let vc = segue.destination as? DetailNewsVC{
                viewControllerClicked = 0
                guard let cell = sender as? UICollectionViewCell else { return }
                guard let indexpath = self.collectionView?.indexPath(for: cell) else { return }
                vc.articleHeadlineString = headlines[indexpath.row]
                vc.datePosted = datePosted[indexpath.row]
                if content[indexpath.row] != "" && contentDescription[indexpath.row] != ""
                {
                    if contentDescription[indexpath.row][0...10] == content[indexpath.row][0...10]{
                        if content[indexpath.row].count > 259{
                            vc.articleContentString = content[indexpath.row][0..<259]
                        }else{
                            vc.articleContentString = content[indexpath.row]
                        }
                    }else{
                        if content[indexpath.row].count > 259{
                            vc.articleContentString = "\(contentDescription[indexpath.row])\n" + "\(content[indexpath.row][0..<259])"
                        }else{
                            vc.articleContentString = "\(contentDescription[indexpath.row])\n" + "\(content[indexpath.row])"
                        }

                    }
                }else{
                    vc.articleContentString = "\(contentDescription[indexpath.row])\n" + "\(content[indexpath.row])"
                }

               
                vc.imageURL = images[indexpath.row]
                vc.urlToArticle = contentURL[indexpath.row]
            }
        }
    }
    
    @objc func scrollToTop(){
        let indexpath = IndexPath(row: 0, section: 0)
        collectionView.scrollToItem(at: indexpath, at: .top, animated: true)
    }

}

extension NewsFeedVC:PopoverContentControllerDelegate {
    func popoverContent(controller: PopoverContentController, didselectItem name: String) {
        navTitleName = name
        let navTitle = NSMutableAttributedString(string: "\(navTitleName) ", attributes:[
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold), NSAttributedString.Key.foregroundColor: collectionView.backgroundColor?.isDarkColor == true ? UIColor.white.cgColor : UIColor.black.cgColor])
        
        navTitle.append(NSMutableAttributedString(string: "\(String.fontAwesomeIcon(name: .chevronDown)) ", attributes:[NSAttributedString.Key.font: UIFont.fontAwesome(ofSize: 12, style: .solid), NSAttributedString.Key.foregroundColor: UIColor.gray.cgColor]))
        sourcesButton.setAttributedTitle(navTitle, for: .normal)
        collectionView.isHidden = true
        Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(refreshNewsFeed(_:)), userInfo: nil, repeats: false)
    }
}


extension NewsFeedVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NewsService.instance.newsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if layout == 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsFeedCell", for: indexPath) as! NewsFeedCell
            cell.configureCell(newsCell: NewsService.instance.newsList[indexPath.item])
            return cell
            
        } else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath) as! SectionNewsFeedCell
            cell.configureCell(newsCell: NewsService.instance.newsList[indexPath.item])
            return cell
        }
        
        
        

        
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if layout == 0{
            var itemHeight: CGFloat {
                return collectionView.bounds.width - 35
            }
            
            var itemWidth: CGFloat {
                return collectionView.bounds.width - 35
            }
            
            return CGSize(width: itemWidth, height: itemHeight)
        } else{
            var itemHeight: CGFloat {
                return 100
            }
            
            var itemWidth: CGFloat {
                return collectionView.bounds.width - 35
            }
            
            return CGSize(width: itemWidth, height: itemHeight)
            
        }

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.alpha = 0.4
        let timeInterval = 0.5
//        cell?.hero.modifiers = [.useNoSnapshot, .spring(stiffness: 250, damping: 25)]
        cell?.hero.modifiers = [.fade, .translate(x: 0, y: -150, z: 0), .duration(timeInterval)]
        //        cell?.hero.modifiers = [.size(CGSize(width: cell!.bounds.width, height: cell!.bounds.width - 35)), .translate(x: 0, y: -300, z: 0), .fade, .duration(1)]
        self.performSegue(withIdentifier: "detailNewsSegue", sender: cell)
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,viewForSupplementaryElementOfKind kind: String,at indexPath: IndexPath) -> UICollectionReusableView {
        
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerCell", for: indexPath)
        
        return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.5){
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10.0
//    }
    
    
    
    
}
extension UIColor
{
    var isDarkColor: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  lum < 0.50 ? true : false
    }
}

class ScalingButton: UIButton {
    
    override func applyStyle(isHighlighted: Bool, highlightColor: UIColor) {
        let scale: CGFloat = isHighlighted ? 1.5 : 1.0
        transform = CGAffineTransform(translationX: scale, y: scale)
    }
    
}
