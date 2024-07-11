//
//  HandWritingViewController.swift
//  TestApp
//
//  Created by wangxu on 2024/7/11.
//

import Foundation

final class HandWritingViewController: UIViewController {
    
    private var handWritingView: HandWritingView = .init()
    private var draftHandWritingView: HandWritingView = .init(recognizionTime: nil, lineColor: UIColor.white.cgColor, isDraft: true)
    
    private var draftButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("切换手写板", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    private var currIsDraftState: Bool = false
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupEvent()
        setupUI()
    }
    
    private func setupEvent() {
        handWritingView.delegate = self
        draftHandWritingView.delegate = self
        
        draftButton.setupTouch { [weak self] _ in
            guard let self else { return }
            self.handWritingView.cleanHandWritingView()
            self.handWritingView.isHidden = !self.currIsDraftState
            
            self.draftHandWritingView.cleanHandWritingView()
            self.draftHandWritingView.isHidden = self.currIsDraftState
            
            self.currIsDraftState.toggle()
        }
    }
    
    @objc func changeState() {
        self.handWritingView.cleanHandWritingView()
        self.handWritingView.isHidden = currIsDraftState
        
        self.draftHandWritingView.cleanHandWritingView()
        self.draftHandWritingView.isHidden = !currIsDraftState
        
        self.currIsDraftState.toggle()
    }
    
    private func setupUI() {
        view.addSubview(handWritingView)
        view.addSubview(draftHandWritingView)
        view.addSubview(draftButton)
        handWritingView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.right.bottom.equalToSuperview()
        }
        handWritingView.isHidden = false
        
        draftHandWritingView.snp.makeConstraints { make in
            make.top.top.equalToSuperview().offset(100)
            make.left.right.bottom.equalToSuperview()
        }
        draftHandWritingView.isHidden = true
        
        draftButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.right.equalToSuperview().offset(-50)
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
    }
}

extension HandWritingViewController: HandWritingRecognizeDelegate {
    func recognize() {
        handWritingView.cleanHandWritingView()
    }
    
    func closeDraftHandWritingView() {
        handWritingView.isHidden = false
        
        draftHandWritingView.cleanHandWritingView()
        draftHandWritingView.isHidden = true
    }
}

protocol HandWritingRecognizeDelegate: AnyObject {
    func recognize()
    func closeDraftHandWritingView()
}

class HandWritingView: UIView {
    struct HandWritingLine {
        var points: [CGPoint]
    }
    
    public weak var delegate: HandWritingRecognizeDelegate?
    
    private var currLines: [HandWritingLine] = []
    private var dropLines: [HandWritingLine] = []
    private var currentLine: HandWritingLine?
    private var recogniteTimer: Timer = .init()
    private var panelView: DraftPanelView = .init()
    
    /// 外部可自定义参数
    private var recognitionTime: TimeInterval? = 0.4
    private var lineWidth: CGFloat = 5
    private var lineColor: CGColor = UIColor.black.cgColor
    private var isDraft: Bool = false
    
    public init(recognizionTime: TimeInterval? = 0.4,
                lineWidth: CGFloat = 5,
                lineColor: CGColor = UIColor.black.cgColor,
                isDraft: Bool = false) {
        self.lineColor = lineColor
        self.isDraft = isDraft
        self.lineWidth = lineWidth
        self.recognitionTime = recognizionTime
        
        super.init(frame: .zero)
        let bgcolor = isDraft ? UIColor.black.withAlphaComponent(0.6) : .clear
        backgroundColor = bgcolor
        setupGestureRecognizer()
        setupUI()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        addSubview(panelView)
        panelView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-100)
            make.bottom.equalToSuperview().offset(-200)
            make.size.equalTo(CGSize(width: 20 * 4 + 30 + 30, height: 40))
        }
        panelView.isHidden = !isDraft
        
        panelView.deleteClosure = { [weak self] in
            guard let self else { return }
            self.cleanHandWritingView()
        }
        
        panelView.dropClosure = { [weak self] in
            guard let self else { return }
            self.dropLastLine()
        }
        
        panelView.returnDropClosure = { [weak self] in
            guard let self else { return }
            self.returnDropLastLine()
        }
        
        panelView.closeClosure = { [weak self] in
            guard let self else { return }
            self.delegate?.closeDraftHandWritingView()
        }
    }
        
    private func setupGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGestureRecognizer)
    }
        
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        switch gesture.state {
        case .began:
            if !isDraft { recogniteTimer.invalidate() }
            currentLine = HandWritingLine(points: [location])
        case .changed:
            currentLine?.points.append(location)
            setNeedsDisplay()
        case .ended:
            if let currentLine = currentLine {
                currLines.append(currentLine)
            }
            currentLine = nil
            setupTimer()
        default:
            break
        }
    }
        
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
            
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor)
        context.setLineCap(.round)
          
        for line in currLines { drawLine(line, in: context) }
        
        if let currentLine = currentLine {
            drawLine(currentLine, in: context)
        }
    }
        
    private func drawLine(_ line: HandWritingLine, in context: CGContext) {
        guard let firstPoint = line.points.first else { return }
        context.beginPath()
        context.move(to: firstPoint)
            
        for point in line.points.dropFirst() {
            context.addLine(to: point)
        }
            
        context.strokePath()
    }
    
    public func cleanHandWritingView() {
        recogniteTimer.invalidate()
        currLines.removeAll()
        dropLines.removeAll()
        setNeedsDisplay()
    }
    
    private func dropLastLine() {
        guard !currLines.isEmpty else { return }
        let line = currLines.removeLast()
        dropLines.append(line)
        setNeedsDisplay()
    }
    
    private func returnDropLastLine() {
        guard !dropLines.isEmpty else { return }
        let line = dropLines.removeLast()
        currLines.append(line)
        setNeedsDisplay()
    }
    
    private func setupTimer() {
        guard let recognitionTime = recognitionTime else { return }
        recogniteTimer = Timer(timeInterval: recognitionTime, target: self, selector: #selector(recognizeHandWriting), userInfo: nil, repeats: false)
        RunLoop.main.add(recogniteTimer, forMode: .common)
    }
    
    @objc private func recognizeHandWriting() {
        delegate?.recognize()
    }
}

fileprivate class DraftPanelView: UIView {
    var deleteClosure: (() -> Void)?
    var dropClosure: (() -> Void)?
    var returnDropClosure: (() -> Void)?
    var closeClosure: (() -> Void)?
    
    private var deleteImageView: UIImageView = .init(image: UIImage(named: "Trash"))
    private var dropImageView: UIImageView = .init(image: UIImage(named: "Drop"))
    private var returnDropImageView: UIImageView = .init(image: UIImage(named: "Refresh"))
    private var closeImageView: UIImageView = .init(image: UIImage(named: "Check"))
    
    init(deleteClosure: ( () -> Void)? = nil, dropClosure: ( () -> Void)? = nil, returnDropClosure: ( () -> Void)? = nil, closeClosure: ( () -> Void)? = nil) {
        self.deleteClosure = deleteClosure
        self.dropClosure = dropClosure
        self.returnDropClosure = returnDropClosure
        self.closeClosure = closeClosure
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.masksToBounds = true

        deleteImageView.setupTouch { [weak self] _ in
            guard let self else { return }
            self.deleteClosure?()
        }
        
        dropImageView.setupTouch { [weak self] _ in
            guard let self else { return }
            self.dropClosure?()
        }
        
        returnDropImageView.setupTouch { [weak self] _ in
            guard let self else { return }
            self.returnDropClosure?()
        }
        
        closeImageView.setupTouch { [weak self] _ in
            guard let self else { return }
            self.closeClosure?()
        }
        
        addSubview(deleteImageView)
        addSubview(dropImageView)
        addSubview(returnDropImageView)
        addSubview(closeImageView)
        
        deleteImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalToSuperview()
        }
        
        dropImageView.snp.makeConstraints { make in
            make.left.equalTo(deleteImageView.snp.right).offset(10)
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalToSuperview()
        }
        
        returnDropImageView.snp.makeConstraints { make in
            make.left.equalTo(dropImageView.snp.right).offset(10)
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalToSuperview()
        }
        
        closeImageView.snp.makeConstraints { make in
            make.left.equalTo(returnDropImageView.snp.right).offset(10)
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalToSuperview()
        }
    }
}
