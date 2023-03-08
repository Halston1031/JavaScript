let Computer = ['CPU', 'DRAM' , 'SSD', 'Mouse'];

// 顯⽰示型別 - 不精準
console.log(typeof Computer); 

// 判斷是否為Array實例例 - 精準
console.log(Computer instanceof Array); 
console.log(Array.isArray(Computer)); 

Addthead(Computer);
Addthead("Halston");
// 防呆
function Addthead(littleComputer){
    if(!Array.isArray(littleComputer)){
        return;
    }
}

let Cars = ['BMW', 'Benz', 'Audi', 'Lexus']; 
for(var i = 0; i < Cars.length; i++)
{
    console.log(Cars[i]); 
} 

let Car = ['BMW', 'Benz', 'Audi', 'Lexus']; 
Car.forEach(function(item, index){ 
    console.log(`${index}, ${item}`) // -> console.log(index, item) 
});
// 或⽤Arrow Function 
Car.forEach((item, index) => { 
    console.log(index, item, typeof item) 
});
// item及index參數名稱也能改成語意較清楚的英文
Car.forEach((car, id) => { 
    console.log(id, car) 
});

// Dynamic Adding
let friends =[]; 
let person1 = {
    id: 1,      
    name: "kevin",     
    email: "kevin@gmail.com"
}; 
let person2 = {
    id: 2,      
    name: "Mary",     
    email: "mary@gmail.com"
}; 
// friends.push(person1); 
// friends.push(person2); 
friends.push(person1, person2); 
console.log(friends);


let person3 = {
    id: 3,      
    name: "Halston",     
    email: "halston@gmail.com"
}; 
friends.unshift(person3); //加在前端

friends.pop(); // pop掉末端, 此處為id = 2

console.log(friends);
