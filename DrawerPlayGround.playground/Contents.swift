
import UIKit

class DrawerNavigationController : UINavigationController{
    
    private var drawerView: UIView?
    private var drawerToggled = false
    private var _xDelta = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initDrawerMenu(){
        let rootViewFrame = self.view.frame
        let offsetX = 0 - rootViewFrame.size.width
        drawerView = UIView(frame: CGRect(x: offsetX, y:  0, width:  rootViewFrame.size.width - 100, height:  rootViewFrame.size.height))
        drawerView?.backgroundColor = UIColor.red
        
        let tapGestureRecogniserForDrawerView = UITapGestureRecognizer(target: self, action:  #selector (self.draweViewClicked (_:)))
        let tapGestureRecogniserForVisibleController = UITapGestureRecognizer(target: self, action:  #selector (self.draweViewClicked (_:)))
        let tapGestureRecogniserForNavbar = UITapGestureRecognizer(target: self, action:  #selector (self.draweViewClicked (_:)))
        let panGestureRecogniserDrawerView = UIPanGestureRecognizer(target: self, action: #selector (self.drawerMovement(_:)))
        let panGestureRecogniserForVisibleController = UIPanGestureRecognizer(target: self, action: #selector (self.drawerMovementFromVisibleController(_:)))
        
        navigationBar.addGestureRecognizer(tapGestureRecogniserForNavbar)
        drawerView?.addGestureRecognizer(tapGestureRecogniserForDrawerView)
        drawerView?.addGestureRecognizer(panGestureRecogniserDrawerView)
        visibleViewController?.view.addGestureRecognizer(panGestureRecogniserForVisibleController)
        visibleViewController?.view.addGestureRecognizer(tapGestureRecogniserForVisibleController)
        
        self.view.addSubview(drawerView!)
    }
    
    @objc func draweViewClicked(_ sender: UITapGestureRecognizer){
        toggleDrawer(fromIndicator: false)
    }
    
    @objc func drawerMovement(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: drawerView!)
        if (((drawerView?.frame.origin.x)! <= CGFloat(0) || (drawerView?.frame.origin.x)! >= (self.view.frame.size.width / 2) - 100) && translation.x <= 0){
            drawerView?.frame.origin.x = translation.x
        }
        if  sender.state == UIGestureRecognizerState.ended {
            if(translation.x > 0 || (drawerView?.frame.origin.x)! >= CGFloat(0)){
                self.drawerView?.frame.origin.x = 0
            } else {
                UIView.animate(withDuration: 0.4) {
                    self.drawerView?.frame.origin.x = 0 - self.view.frame.size.width
                }
            }
        }
    }
    
    @objc func drawerMovementFromVisibleController(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: visibleViewController?.view!)
        if ((drawerView?.frame.origin.x)! < CGFloat(0) || (drawerView?.frame.origin.x)! >= self.view.frame.size.width - 100){
            print(translation.x)
            drawerView?.frame.origin.x = (0 - self.view.frame.size.width) + translation.x
        }
        if  sender.state == UIGestureRecognizerState.ended {
            if(translation.x > 0){
                self.drawerView?.frame.origin.x = 0
            } else {
                UIView.animate(withDuration: 0.4) {
                    self.drawerView?.frame.origin.x = 0 - self.view.frame.size.width
                }
            }
        }
    }
    
    func toggleDrawer(fromIndicator: Bool = true){
        drawerToggled = drawerView?.frame.origin.x != 0
        UIView.animate(withDuration: 0.4) {
            if(!fromIndicator){
                self.drawerView?.frame.origin.x = 0 - self.view.frame.size.width
            } else {
                if(!self.drawerToggled){
                    self.drawerView?.frame.origin.x = 0 - self.view.frame.size.width
                } else {
                    self.drawerView?.frame.origin.x = 0
                }
            }
        }
    }
}

