require('UIView,UIColor');
defineClass('ViewController', {
    viewDidLoad: function() {
        self.super().viewDidLoad();
        self.getSubView();
    },getSubView: function() {
            var itemRect = {x:20, y:64, width:200, height:100};
            var subView = UIView.alloc().initWithFrame(itemRect);
            subView.setBackgroundColor(UIColor.redColor());
            subView.layer().setCornerRadius(10.0);
            subView.layer().setMasksToBounds(YES);
            self.view().addSubview(subView);
            },
            });
defineClass('SecondTestViewController', {
    viewDidLoad: function() {
        self.super().viewDidLoad();
        self.getSubView();
    },getSubView: function() {
            var itemRect = {x:120, y:64, width:200, height:100};
            var subView = UIView.alloc().initWithFrame(itemRect);
            subView.setBackgroundColor(UIColor.redColor());
            subView.layer().setCornerRadius(10.0);
            subView.layer().setMasksToBounds(YES);
            self.view().addSubview(subView);
            },
            });
