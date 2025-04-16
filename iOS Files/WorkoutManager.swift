import Foundation
import HealthKit
import WatchConnectivity

class WorkoutManager: NSObject, ObservableObject, WCSessionDelegate {
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?

    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0

    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func startWorkout() {
        let config = HKWorkoutConfiguration()
        config.activityType = .other
        config.locationType = .indoor

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: config)
            builder = session?.associatedWorkoutBuilder()
            builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: config)

            session?.startActivity(with: Date())
            builder?.beginCollection(withStart: Date()) { _, _ in }

            builder?.delegate = self
        } catch {
            print("Workout start failed: \(error)")
        }
    }

    func endWorkout() {
        session?.end()
    }

    func sendXP(_ xp: Int) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["xp": xp], replyHandler: nil, errorHandler: nil)
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}

extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf types: Set<HKSampleType>) {
        if types.contains(HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!) {
            if let stats = workoutBuilder.statistics(for: .init(.activeEnergyBurned)) {
                activeEnergy = stats.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                sendXP(Int(activeEnergy)) // For example, 1 XP per kcal
            }
        }
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {}
}
