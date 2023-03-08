let person = { 
    name: "Halston", 
    age: 22,                
    height: 160, 
    weight: 50 
}; 

console.log(person);
console.log(person.name);
console.log(person['age']);

let keys = Object.keys(person); 
let values = Object.values(person); 
console.log(keys, values);

keys.forEach(key=>{
    console.log(key, person[key]);
});

console.log("This  Object is " + person); 
console.log("This  Object is  %o", person);  //轉型

let jsonText = JSON.stringify(person);  // 將任何物件轉變為 JSON 字串
console.log(jsonText); 
console.log(typeof jsonText); // string

let p = JSON.parse(jsonText); // 將 JSON 字串解析成 JavaScript 物件
console.log(p); 
console.log(typeof p); // object