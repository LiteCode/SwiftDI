//
//  CommonViewController.swift
//  VKNavigationController
//
//  Created by v.a.prusakov on 08/07/2019.
//  Copyright © 2019 Vladislav Prusakov. All rights reserved.
//

import UIKit


public extension UIImage {

    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            color.setFill()
            let rect = CGRect(origin: .zero, size: size)
            UIRectFill(rect)
        }
        guard let cgImage = image.cgImage else { return nil }
        self.init(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }

}

public extension Collection {

    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    var nilIfEmpty: Self? {
        return self.isEmpty ? nil : self
    }

}


open class CommonViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Если цвет nil, то устанавливается стандартный фон `UINavigationBar`
    /// - note: По дефолту `UIColor.clear`
    open var navigationBarColor: UIColor? {
        return .clear
    }
    
    /// Убирает тень UINavigationBar.
    /// - note: По дефолту `true`, использует KVC.
    open var isNavigationBarShadowHidden: Bool {
        return true
    }
    
    open var navigationBarTintColor: UIColor {
        return .black
    }
//
    open var navigationBarStyle: UIBarStyle {
        return .default
    }
    
    private var _preferredStyle = UIStatusBarStyle.default;
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return _preferredStyle
        }
        set {
            _preferredStyle = newValue
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
    }
    
    /*
     на iOS 11
     https://stackoverflow.com/questions/39835420/navigationbar-delay-updating-bartintcolor-ios10/40255483
     https://stackoverflow.com/questions/39511088/navigationbar-coloring-in-viewwillappear-happens-too-late-in-ios-10/40377268#40377268
     При переходе с SecondViewController на FirstViewController (pop transition) - навигейшн обновляется с задержкой.
     Сейчас при закрытии второго контроллера обновляется appearance на первом.
     */
    private var previousViewController: CommonViewController? {
        guard let navigationController = self.navigationController else { return nil }
        return navigationController.viewControllers[safe: navigationController.viewControllers.count - 2] as? CommonViewController
    }
    
    // MARK: - Life cycle
    
    override open func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
//        if let last = self.navigationController?.viewControllers.last as? CommonViewController {
//            if last == self && self.navigationController!.viewControllers.count > 1{
//                if let parent = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2] as? CommonViewController {
//                    parent.setupAppearance()
//                }
//            }
//        }
    }
    
    var flag = false
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !flag {
            self.setupAppearance()
            flag = true
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        if let parent = navigationController?.viewControllers.last as? CommonViewController {
            parent.animateNavigationColors()
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        self.setupAppearance()
    }
    
    func animateNavigationColors(){
        let to = transitionCoordinator?.viewController(forKey: .from)
        self.preferredStatusBarStyle = to?.preferredStatusBarStyle ?? .default
//        from?.preferredStatusBarStyle = self.navigationBarStyle.statusBar
//        self.navigationController?.setNeedsStatusBarAppearanceUpdate()
        transitionCoordinator?.animate(alongsideTransition: { [weak self] (context) in
            self?.setupAppearance()
        }, completion: nil)
    }
    
    // MARK: - Private
    
    private func setupAppearance() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        self.updateNavigationBar(navigationBar)
        self.updateNavigationBarStyle(navigationBar)
        
    }
    
    public func updateNavigationBarTitle(_ navigationBar: UINavigationBar) {
        
    }
    
    public func updateNavigationBar(_ navigationBar: UINavigationBar) {
        
        navigationBar.setBackgroundImage(self.navigationBarColor.flatMap { UIImage(color: $0, size: navigationBar.frame.size) }, for: .default)
        
        if self.isNavigationBarShadowHidden {
            navigationBar.setValue(true, forKey: "hidesShadow")
            navigationBar.shadowImage = UIImage()
        } else {
            navigationBar.setValue(false, forKey: "hidesShadow")
            navigationBar.shadowImage = nil
        }
        navigationBar.tintColor = self.navigationBarTintColor
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .done, target: nil, action: nil)
        navigationBar.titleTextAttributes = [ .foregroundColor : self.navigationBarTintColor ]
        
    }
    
    public func updateNavigationBarStyle(_ navigationBar: UINavigationBar) {
        guard navigationBar.barStyle != self.navigationBarStyle else { return }
        navigationBar.barStyle = self.navigationBarStyle
        self.preferredStatusBarStyle = self.navigationBarStyle.statusBar
        self.navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    
}

extension UIBarStyle {
    var statusBar: UIStatusBarStyle {
        return self == .default ? .default : .lightContent
    }
}

class MyNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return visibleViewController!.preferredStatusBarStyle
    }
}
