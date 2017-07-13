//
//  FFSliderView.swift
//  fashionfrau
//
//  Created by Nilson Junior on 15/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit

public protocol FFSliderDataSource: class {

    func slider(ffSliderNumberOfSlides slider: FFSliderView) -> Int

    func slider(slider: FFSliderView, viewForSlideAtIndex index: Int) -> UIView
}


public class FFSliderView: UIView {

    public weak var datasource: FFSliderDataSource?

    var numbersOfSlides: Int = 0
    var ffSliderScrollView: UIScrollView!
    var pageControl: UIPageControl!


    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._setupUI()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self._setupUI()
    }


    public override func layoutSubviews() {
        super.layoutSubviews()
        self._adapterUI()
        self._prepareDataSource()
    }

    public func reloadData(){
        self._adapterUI()
        self._prepareDataSource()
    }

    private func _prepareDataSource(){
        if let dataSource = self.datasource {

            //Set number of slides
            self.numbersOfSlides = dataSource.slider(ffSliderNumberOfSlides: self)
            self.pageControl.numberOfPages = self.numbersOfSlides

            //Set widht and height
            let scrollViewWidth  : CGFloat  = self.ffSliderScrollView.frame.width
            let scrollViewHeight : CGFloat  = self.ffSliderScrollView.frame.height

            if self.numbersOfSlides == 0 {

                self.pageControl.isHidden        = true
                self.ffSliderScrollView.isHidden = true

            } else if self.numbersOfSlides > 0{

                for i in 0...(self.numbersOfSlides - 1) {

                    let x      = CGFloat(i) * scrollViewWidth
                    let view   = dataSource.slider(slider: self, viewForSlideAtIndex: i)
                    view.frame = CGRect(x: x, y: 0, width: scrollViewWidth, height: scrollViewHeight)
                    self.ffSliderScrollView.addSubview(view)
                }

                self.ffSliderScrollView.contentSize = CGSize(width: self.ffSliderScrollView.frame.width * CGFloat(integerLiteral: self.numbersOfSlides), height: self.ffSliderScrollView.frame.height)

                self.ffSliderScrollView.delegate = self
                self.pageControl.currentPage     = 0
            }
        }
    }

    private func _setupUI(){

        //Setup ScrollView
        self.ffSliderScrollView = UIScrollView()

        self.ffSliderScrollView.isScrollEnabled = true
        self.ffSliderScrollView.isPagingEnabled = true
        self.ffSliderScrollView.bounces       = false

        self.ffSliderScrollView.showsHorizontalScrollIndicator = false
        self.ffSliderScrollView.showsVerticalScrollIndicator   = false

        self.addSubview(self.ffSliderScrollView)

        //Setup PageControl
        self.pageControl = UIPageControl()
        self.pageControl.currentPageIndicatorTintColor = UIColor.fashionfrau
        self.pageControl.pageIndicatorTintColor = UIColor.white
        
        self.addSubview(self.pageControl)
    }

    private func _adapterUI(){

        self.ffSliderScrollView.frame = self.frame
        self.pageControl.frame.origin.x = self.center.x
        self.pageControl.frame.origin.y = self.frame.size.height - 20
    }
}

extension FFSliderView: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.ffSliderScrollView {

            // Test the offset and calculate the current page after scrolling ends
            let pageWidth:CGFloat   = self.ffSliderScrollView.frame.size.width
            let currentPage:CGFloat = floor((self.ffSliderScrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
            
            self.pageControl.currentPage = Int(currentPage);
        }
    }
}
