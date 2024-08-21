import UIKit

class PresentationController: UIPresentationController {
    private var blurEffectView: UIVisualEffectView!
    private var tapGestureRecognizer: UITapGestureRecognizer!
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.addGestureRecognizer(tapGestureRecognizer)
        
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect()
        }
        let customHeight: CGFloat = containerView.bounds.height * 0.5 // Adjust this value as needed
        let originY = containerView.bounds.height - customHeight
        return CGRect(x: 0, y: originY, width: containerView.bounds.width, height: customHeight)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        blurEffectView.frame = containerView.bounds
        containerView.addSubview(blurEffectView)
        containerView.addSubview(presentedView!)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView.alpha = 0.5
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView.alpha = 0.0
        }, completion: { _ in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    @objc private func dismissController() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        // Adjust the presented view's frame to account for the keyboard
        let keyboardHeight = keyboardFrame.height
        if let presentedView = presentedView {
            presentedView.frame.origin.y = containerView!.bounds.height - presentedView.frame.height - keyboardHeight + containerView!.safeAreaInsets.bottom
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // Reset the presented view's frame when the keyboard hides
        if let presentedView = presentedView {
            presentedView.frame.origin.y = containerView!.bounds.height - presentedView.frame.height
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
