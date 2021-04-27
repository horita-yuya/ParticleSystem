import SpriteKit
import UIKit
import SceneKit

final class ConfettiView: UIView {
    //    private let skView = SKView()
    private let scnView = SCNView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return self == view ? nil : view
    }
}

private extension ConfettiView {
    func configure() {
        backgroundColor = .clear

        addSubview(scnView)
        scnView.translatesAutoresizingMaskIntoConstraints = false
        scnView.isUserInteractionEnabled = false
        scnView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            scnView.topAnchor.constraint(equalTo: topAnchor),
            scnView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scnView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scnView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        let scene = SCNScene()
        let confettiP = SCNParticleSystem(named: "Confetti.scnp", inDirectory: "")!
        let confetti: SCNParticleSystem = {
            let confetti = SCNParticleSystem()
            confetti.birthRate = 50
            confetti.particleImage = image()//Asset.janken.image
            confetti.blendMode = .alpha

            confetti.emitterShape = SCNBox(width: 10, height: 0, length: 5, chamferRadius: 0)
            confetti.emittingDirection = .init(0, 0, 1)

            confetti.particleColor = .red
            confetti.particleColorVariation = SCNVector4(180, 0.1, 0.1, 0)
            confetti.particleSize = 0.1
            confetti.particleSizeVariation = 0.05

            confetti.particleLifeSpan = 20
            confetti.particleAngularVelocity = 300
            confetti.dampingFactor = 5

            confetti.isAffectedByGravity = true
            confetti.orientationMode = .free
            return confetti
        }()
        print(type(of: confettiP.particleImage))
        print(confettiP.particleImage)
        print((confettiP.particleImage as? UIImage)?.size)

        scene.rootNode.addParticleSystem(confetti)
        scene.background.contents = nil

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: -10, z: 20)

        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
    }
}

//private extension ConfettiView {
//    func configure() {
//        backgroundColor = .clear
//
//        addSubview(skView)
//        skView.translatesAutoresizingMaskIntoConstraints = false
//        skView.isUserInteractionEnabled = false
//        skView.allowsTransparency = true
//        skView.edgesToSuperview()
//
//        let scene = SKScene(size: bounds.size)
//        scene.anchorPoint = .init(x: 0.5, y: 0.5)
//        scene.backgroundColor = .clear
//        skView.presentScene(scene)
//
//        let particle = SKEmitterNode()
//        particle.particleBirthRate = 30
//        particle.numParticlesToEmit = 1000
//        particle.particleLifetime = 8
//
//        particle.particleSpeed = -80
//        particle.particleSpeedRange = -100
//        particle.particleRotationRange = .pi
//        particle.particleRotationSpeed = .pi / 4
//        particle.yAcceleration = -10
//
//        particle.particleSize = .init(width: 4, height: 8)
//        particle.particleScaleRange = 0.8
//        particle.particleTexture = SKTexture(image: image())
//
//        particle.emissionAngleRange = .pi / 6
//
//        particle.position = .init(x: 0, y: bounds.size.height / 2)
//        particle.particlePositionRange = .init(dx: bounds.size.width, dy: 0)
//
//        particle.particleColorBlendFactor = 1
//        particle.particleColor = .white
//        particle.particleColorRedRange = 0.2
//        particle.particleColorBlueRange = 0.2
//        particle.particleColorGreenRange = 0.2
//        skView.scene?.addChild(particle)
//    }
//
func image() -> UIImage {
    let rect = CGRect(origin: .zero, size: .init(width: 80, height: 32))
    return UIGraphicsImageRenderer(size: rect.size).image { context in
        context.cgContext.setFillColor(UIColor.white.cgColor)
        let path = CGPath(ellipseIn: rect, transform: nil)
        context.cgContext.addPath(path)
        context.cgContext.fillPath()
    }
}
//}
