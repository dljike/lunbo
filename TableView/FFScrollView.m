
#import "FFScrollView.h"

@implementation FFScrollView
@synthesize scrollView;
@synthesize pageControl;
@synthesize selectionType;
@synthesize pageViewDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

#pragma mark-- init methods
- (id)initPageViewWithFrame:(CGRect)frame views:(NSMutableArray *)views
{
    self = [super initWithFrame:frame];
    if (self) {
        selectionType = FFScrollViewSelecttionTypeTap;
        sourceArr = views;
        
        self.userInteractionEnabled = YES;
        [self iniSubviewsWithFrame:frame];
    }
    return self;
}
-(void)initWithImgs:(NSArray *)views
{
    selectionType = FFScrollViewSelecttionTypeTap;
    sourceArr =[[NSArray alloc]initWithArray:views?views:@[]];
    
    self.userInteractionEnabled = YES;
    [self iniSubviewsWithFrame:self.frame];
}
-(void)iniSubviewsWithFrame:(CGRect)frame
{
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    CGRect fitRect = CGRectMake(0, 0, width, height);
    
    if (self.scrollView) {
        [self.scrollView removeFromSuperview],self.scrollView=nil;
    }
    self.scrollView = [[UIScrollView alloc]initWithFrame:fitRect];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(width*(sourceArr.count+2), height);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    if (firstImageView) {
        [firstImageView removeFromSuperview],firstImageView=nil;
        [timer invalidate];
    }
    firstImageView = [[UIImageView alloc]initWithFrame:fitRect];
    // 最后一张图片
    firstImageView.image = [UIImage imageNamed:@"4.png"];
    firstImageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:firstImageView];
    // 所有图片
    
    for (int i = 0; i < sourceArr.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(width*(i+1), 0, width, height)];
        // 用sdwebimg显示
        imageview.image  = [UIImage imageNamed:sourceArr[i]];
 
        imageview.contentMode=UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:imageview];
    }
    if (lastImageView) {
        [lastImageView removeFromSuperview],lastImageView=nil;
    }
    
    lastImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width*(sourceArr.count+1), 0, width, height)];
    if (sourceArr.count==0) {
        // 没有图片的时候占位符
        lastImageView.image = [UIImage imageNamed:@"4.png"];
    }
    else
    {
 
        // 第一个图片
//        [lastImageView sd_setImageWithURL:[NSURL URLWithString: [[sourceArr objectAtIndex:0] safeObjectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"topad-no-pic.png"]];
        lastImageView.image = [UIImage imageNamed:@"1.png"];
        
        
    }
    lastImageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:lastImageView];
    
    if (self.pageControl) {
        [self.pageControl removeFromSuperview],self.pageControl=nil;
    }
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, height-30, width, 30)];
    self.pageControl.numberOfPages = sourceArr.count;
    self.pageControl.currentPage = 0;
    self.pageControl.enabled = YES;
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:self.pageControl];
    
 
    
    [self.scrollView scrollRectToVisible:CGRectMake(width, 0, width, height) animated:NO];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    if (sourceArr.count>1) {
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextPage:) userInfo:nil repeats:YES];
        self.scrollView.scrollEnabled=YES;
    }
    else
    {
        self.scrollView.scrollEnabled=NO;
    }
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
}

#pragma mark --- custom methods
//自动滚动到下一页
-(IBAction)nextPage:(id)sender
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int currentPage = self.scrollView.contentOffset.x/pageWidth;
    if (currentPage == 0) {
        self.pageControl.currentPage = sourceArr.count-1;
   
    }
    else if (currentPage == sourceArr.count+1) {
        self.pageControl.currentPage = 0;

    }
    else {
        self.pageControl.currentPage = currentPage-1;

    }
    NSInteger currPageNumber = self.pageControl.currentPage;
    CGSize viewSize = self.scrollView.frame.size;
    CGRect rect = CGRectMake((currPageNumber+2)*pageWidth, 0, viewSize.width, viewSize.height);
    [self.scrollView scrollRectToVisible:rect animated:YES];
    currPageNumber++;
    if (currPageNumber == sourceArr.count)
    {
        CGRect newRect=CGRectMake(viewSize.width, 0, viewSize.width, viewSize.height);
        [self.scrollView scrollRectToVisible:newRect animated:NO];
        currPageNumber = 0;
    }
    self.pageControl.currentPage = currPageNumber;
    if ([pageViewDelegate respondsToSelector:@selector(scrollPage:)])
    {

    }
}

//点击图片的时候 触发
- (void)singleTap:(UITapGestureRecognizer *)tapGesture
{
    if (selectionType != FFScrollViewSelecttionTypeTap) {
        return;
    }
    
//     NSLog(@"点击了图片：%i",self.pageControl.courent);
    
    if(sourceArr.count==1&&[[[sourceArr objectAtIndex:0] objectForKey:@"medium"] isEqualToString:@""])
    {
        if ([pageViewDelegate respondsToSelector:@selector(isNormalPic)]) {
            [pageViewDelegate isNormalPic];
        }
    }
    else
    {
        if (pageViewDelegate && [pageViewDelegate respondsToSelector:@selector(scrollViewDidClickedAtPage:)]) {
            [pageViewDelegate scrollViewDidClickedAtPage:self.pageControl.currentPage];

//            NSLog(@"点击了图片：%i",self.pageControl.courent);
        }
    }
    
}

#pragma mark---- UIScrollView delegate methods
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //开始拖动scrollview的时候 停止计时器控制的跳转
    [timer invalidate];
    timer = nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat heigth = self.scrollView.frame.size.height;
    int currentPage = self.scrollView.contentOffset.x/width;
    if (currentPage == 0) {
        [self.scrollView scrollRectToVisible:CGRectMake(width*sourceArr.count, 0, width, heigth) animated:NO];
        self.pageControl.currentPage = sourceArr.count-1;
    }
    else if (currentPage == sourceArr.count+1) {
        [self.scrollView scrollRectToVisible:CGRectMake(width, 0, width, heigth) animated:NO];
        self.pageControl.currentPage = 0;
    }
    else {
        self.pageControl.currentPage = currentPage-1;
    }

    if (sourceArr.count>1) {
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextPage:) userInfo:nil repeats:YES];
        self.scrollView.scrollEnabled=YES;
    }
    else
    {
        self.scrollView.scrollEnabled=NO;
    }
    
    if ([pageViewDelegate respondsToSelector:@selector(scrollPage:)]) {
        [pageViewDelegate scrollPage:self.pageControl.currentPage];
    }
}

@end
