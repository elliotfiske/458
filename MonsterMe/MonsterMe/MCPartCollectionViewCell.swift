/****
 * The MCPartCollectionViewCell class defines a cell that encapsulates one Template for a part.
 *  It's a UICollectionViewCell so it can be dynamically reused in the partsCollectionView.
 */
class MCPartCollectionViewCell: UICollectionViewCell {
    var template: MCPartTemplate!
    var label: UILabel!
    let circleView: UIView = UIView()
    var partImageView: UIImageView!
    
    /**
     * When a part is dragged off, we tint the image view gray.  Make sure we can remember what it should return to
     *  when the part comes back.
     */
    var savedTintColor: UIColor?
    
    // Give us a global handle to the current cell this was dragged from
    private struct CurrPartCell { static var currCell: MCPartCollectionViewCell? = nil }
    class var currCell: MCPartCollectionViewCell? {
        get { return CurrPartCell.currCell }
        set { CurrPartCell.currCell = newValue }
    }
    
    override init(frame: CGRect) {
        var realFrame = frame
        realFrame.origin.y = 0
        
        circleView.frame = CGRect(origin: CGPointZero, size: CGSize(width: 80, height: 60))
        circleView.backgroundColor = UIColor.whiteColor()
        roundView(circleView, toDiameter: circleView.frame.width)
        
        partImageView = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 60, height: 60)))
        partImageView.contentMode = .ScaleAspectFit
        partImageView.center = circleView.center
        
        label = UILabel(frame: CGRect(x: 0, y: circleView.frame.height, width: frame.width, height: 25))
        label.font = leagueFont(20)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        
        super.init(frame: realFrame)
        
        addSubview(label)
        addSubview(circleView)
        addSubview(partImageView)
        
        let tapper = UITapGestureRecognizer(target: self, action: "doTap:")
        addGestureRecognizer(tapper)
    }
    
    /**
     * Nudge the part a bit on tap to hint the user to drag it.
     */
    func doTap(tap: UITapGestureRecognizer) {
        if tap.state == .Ended {
            let tempGrayImage = partImageView.image!.copy() as UIImage
            let tempGrayView = UIImageView(image: tempGrayImage)
            tempGrayView.contentMode = .ScaleAspectFit
            tempGrayView.alpha = 0.5
            tempGrayView.tintColor = UIColor.grayColor()
            
            tempGrayView.frame = partImageView.frame
            insertSubview(tempGrayView, belowSubview: partImageView)
            
            UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: {
                [unowned self] in
                self.partImageView.frame.origin.y -= 10
                }, completion: nil)
            
            UIView.animateWithDuration(0.2, delay: 0.2, options: nil, animations: {
                [unowned self] in
                self.partImageView.frame.origin.y += 10
                tempGrayView.alpha = 0.2
                }, completion: {
                    (Bool) in
                    tempGrayView.removeFromSuperview()
            })
        }
    }
    
    /**
     * Tell the cell which template it'll be using.  This generates the
     *  UIImage for the cell and the label's text.
     */
    func setTemplate(template_: MCPartTemplate) {
        template = template_
        
        partImageView.image = template.imageForPart()
        partImageView.frame.size = CGSize(width: 60, height: 60)
        let imgSize = partImageView.image!.size
        if imgSize.width < partImageView.frame.width && imgSize.height < partImageView.frame.height {
            partImageView.frame.size = imgSize
        }
        partImageView.center = circleView.center
        
        if template.colorable {
            partImageView.tintColor = template.color
        }
        else{
            partImageView.tintColor = nil
            
        }
        
        label.text = template.displayName
    }
    
    /** The cell's part has been removed.  Color it gray until it respawns */
    func partRemoved() {
        savedTintColor = partImageView.tintColor
        partImageView.tintColor = UIColor.grayColor()
        partImageView.alpha = 0.5
        
        MCPartCollectionViewCell.currCell = self
    }
    
    /** The user placed / dropped the part from this cell.  Bring it on back. */
    func respawnPart() {
        // Keep a copy of the gray part.  We'll grow the real part back on top of it.
        let grayPartView = UIImageView(frame: partImageView.frame)
        grayPartView.image = partImageView.image
        grayPartView.contentMode = UIViewContentMode.ScaleAspectFit
        grayPartView.tintColor = UIColor.grayColor()
        grayPartView.alpha = 0.5
        
        insertSubview(grayPartView, aboveSubview: circleView)
        bringSubviewToFront(partImageView)
        
        if template.colorable {
            partImageView.tintColor = template.color
        }
        else {
            partImageView.tintColor = nil
        }
        partImageView.alpha = 1
        
        partImageView.transform = CGAffineTransformMakeScale(0, 0)
        UIView.animateWithDuration(0.2, animations: {
            [unowned self] in
            self.partImageView.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: {
                (Bool) in
                grayPartView.removeFromSuperview()
        })
        MCPartCollectionViewCell.currCell = nil
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented... or HAS IT? No it hasn't.  It hasn't.")
    }
}