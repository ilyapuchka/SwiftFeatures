//: ## Swift interesting features
//:
//: or What Swift Language Guide do not tell you.
//:
//: This playground contains interesting features of Swift that I find while using it. The list is intended to be updated in future.
//:
//: ----
//:
//: ### **Var in for-in loop**
//: If you have an array of reference type objects you can mutate them in a loop just adding var before loop veriable. This will work only for reference types as value types are copied on assignment and so the items in array will be not modified. If you have value types though you will be able to modify varable inside the loop. It will work pretty much like mutable function arguments.

class Box {
    var value: Int
    init(_ value:Int) {
        self.value = value
    }
}

var objectsArray = [Box(1), Box(2), Box(3)]
for (var item) in objectsArray {
    item.value++
}
objectsArray

var valuesArray = [1, 2, 3]
for (var item) in objectsArray {
    item.value++
}

//: ### **Property observers for local variables**
//: This does not work in plyagrounds but give it a try in a real project and you will see "Will set 1" and "Did set 1".

func method() {
    
    var some: Int = 0 {
        willSet {
            println("Will set \(newValue)")
        }
        didSet {
            println("Did set \(some)")
        }
    }
    some = 1
}

method()

//: ### **~= operator**
//: You can use expression matching operator to find out if Range contains value. Also switch statement uses ~= operator for pattern matching.

let some = 1
if 0...5 ~= some {
    println("\(some) is between 0 and 5")
}

//: You can override this operator like any other to crate some crazy things. Here are the [docs](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Patterns.html#//apple_ref/doc/uid/TP40014097-CH36-XID_909) for that operator.

typealias Age = UInt

enum Gender {
    case Male
    case Female
}

class Person {
    
    var name: String
    var age: Age
    var gender: Gender
    
    init(_ name: String, age: Age, gender: Gender) {
        self.name = name
        self.age = age
        self.gender = gender
    }
    
    func growOlder(years: Age) {
        self.age += years
    }
}

func ~=(pattern: Person, value: Person) -> Bool {
    return pattern == value
}

func ==(lhs: Person, rhs: Person) -> Bool {
    return lhs.name == rhs.name && lhs.age == rhs.age && lhs.gender == rhs.gender
}

let Ilya = Person("Ilya", age: 28, gender: .Male)
let Marina = Person("Marina", age: 27, gender: .Female)

let me = Ilya

switch me {
case Ilya:
    println("Hi, man!")
case Marina:
    println("Hi, gorgeous!")
default:
    println()
}

func ~=(pattern:Range<Age>, value: Person) -> Bool {
    return pattern ~= value.age
}

switch me {
case 0...18:
    println("You can not drink beer yet")
case 18...(UInt.max - 1):
    println("Do what ever you want")
default:
    println()
}

//: Unfortunatelly complier will not let you to match your class against tuple or enum, which would be cool, but you can still use ~= dircetly if you define it with tuple or enum as a pattern to match. To make it better you can swap right and left hand statements. But still I don't see very good usecases for that.

func ~=(pattern: Gender, value: Person) -> Bool {
    return pattern == value.gender
}

switch me {
case me where .Male ~= me:
    println("Hi, man!")
case me where .Female ~= me:
    println("Hi, gorgeous!")
default:
    println()
}

func ~=(pattern: Person, value: Gender) -> Bool {
    return pattern.gender == value
}

switch me {
case me where me ~= .Male:
    println("Hi, man!")
case me where me ~= .Female:
    println("Hi, gorgeous!")
default:
    println()
}

//: ### **Curried functions**
//: Instance methods in Swift are actually curried functions. You can store it in variable and apply to different instances. Checkout [this post](http://oleb.net/blog/2014/07/swift-instance-methods-curried-functions/) by Ole Begemann for one of use cases for that feature.

let growOlder = Person.growOlder
growOlder(Ilya)(5)
Ilya
growOlder(Marina)(5)
Marina

//: ### **Subscript with multiple parameters**
//: Did you know that you can provide more that one paramtere to subscript?
//: Also ++ will not just change returned value but will also write it back to that subscript.

extension Dictionary {
    subscript(key: Key, # or: Value) -> Value {
        get {
            return self[key] ?? or
        }
        set {
            self[key] = newValue
        }
    }
}

var dict: [String: Int] = ["1": 1]
dict["1"]?++
dict

dict["2", or: 3]++
dict


