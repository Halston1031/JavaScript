let Cars = ["BMW", "Benz", "Toyota", "Tahoma"]
let index = Cars.indexOf("Audi")
console.log(index)

let idx = Cars.findIndex(c =>c == 'Benz')
console.log(idx)

let Price = [200, 320, 250, 210]
console.log(Prices.findIndex(p => p > 300))
console.log(Prices.findIndex(p => p > 250))

Price.filter(function(item, index) { 
    if(item >= 250){
        console.log(`${Cars[index]}'s price is$ {item}, it's price above $250`)
    }
});

let result = Price.filter(function(item, index) { 
    if(item >= 250){
        console.log(`${Cars[index]}'s price is$ {item}, it's price above $250`)

        return true
    }
});

console.log(result)
