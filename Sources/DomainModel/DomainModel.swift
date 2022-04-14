struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}
////////////////////////////////////
// Money
//
public struct Money {
    let amount: Int
    var currency: String
    
    func convert(_ convert: String) -> Money{
        let convertedUSDMoney = getUSDAmount(dollar: Money(amount: self.amount, currency: self.currency))
        
        let convertedMoney = USDConverter(dollar: Money(amount: convertedUSDMoney.amount, currency: convert ))
        
        return convertedMoney
    }
    
    func getUSDAmount(dollar: Money) -> Money {
        switch dollar.currency{
        case "GBP":
            return Money(amount: dollar.amount * 2, currency: "USD")
        case "EUR":
            return Money(amount: Int(Double(dollar.amount) / 1.5), currency: "USD")
        case "CAN":
            return Money(amount: Int(Double(dollar.amount) / 1.25), currency: "USD")
        default:
            return dollar
        }
    }
    
    func USDConverter(dollar: Money) -> Money {
        switch dollar.currency{
        case "GBP":
            return Money(amount: dollar.amount / 2, currency: "GBP")
        case "EUR":
            return Money(amount: Int(Double(dollar.amount) * 1.5), currency: "EUR")
        case "CAN":
            return Money(amount: Int(Double(dollar.amount) * 1.25), currency: "CAN")
        default:
            return dollar
        }
    }
    
    func add(_ money: Money) -> Money {
        let lhs = getUSDAmount(dollar: Money(amount: self.amount, currency: self.currency))
        let rhs = getUSDAmount(dollar: money)
        
        return USDConverter(dollar: Money(amount: lhs.amount + rhs.amount, currency: money.currency))
    }
    
    func subtact(_ money: Money) -> Money {
        let lhs = getUSDAmount(dollar: Money(amount: self.amount, currency: self.currency))
        let rhs = getUSDAmount(dollar: money)
        
        return USDConverter(dollar: Money(amount: lhs.amount - rhs.amount, currency: money.currency))
    }
    
    
}

////////////////////////////////////
// Job
//
public class Job {
    let title: String
    var type: JobType
    
    init(title: String, type: JobType){
        self.title = title
        self.type = type
    }
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    func calculateIncome(_ time: Int) -> Int {
        switch type {
        case .Hourly(let double):
            return Int(double * Double(time))
        case .Salary(let uInt):
            return Int(uInt)
        }
    }
    
    func raise(byAmount: Double) {
        switch type {
        case .Hourly(let double):
            self.type = .Hourly(double + Double(byAmount))
        case .Salary(let uInt):
            self.type = .Salary(uInt + UInt(byAmount))
        }
    }
    
    func raise(byPercent: Double) {
        switch type {
        case .Hourly(let double):
            self.type = .Hourly(double * (1.0 + byPercent))
        case .Salary(let uInt):
            self.type = .Salary(UInt(Double(uInt) * (1.0 + byPercent)))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    let firstName: String
    let lastName: String
    let age: Int
    
    private var _job: Job? = nil
    var job: Job?{
        get{
            return _job
        }
        set(newJob){
            if(age >= 16){
                _job = newJob
            }
        }
    }
    
    private var _spouse: Person? = nil
    var spouse: Person?{
        get{
            return _spouse
        }
        set(newSpouse){
            if(age >= 16){
                _spouse = newSpouse
            }
        }
    }
    
    
    init(firstName: String, lastName: String, age: Int){
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job) spouse:\(self.spouse)]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]
    let spouse1: Person
    let spouse2: Person
    
    init(spouse1: Person, spouse2:Person){
        self.spouse1 = spouse1
        self.spouse2 = spouse2
        
        if(spouse1.spouse == nil && spouse2.spouse == nil){
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
        } else{
            print("one member already has a spouse")
        }
        
        self.members = [spouse1, spouse2]
    }
    
    func haveChild(_ child: Person) -> Bool{
        if(spouse1.age < 21 && spouse2.age < 21){
            return false
        } else {
            self.members.append(child)
            return true
        }
    }

    func householdIncome() -> Int {
        var count = 0
        for i in members {
            if(i.job != nil){
                count += i.job!.calculateIncome(2000)
            }
        }
        return count
    }



}

