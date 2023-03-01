/*
var x = 1; 
var x;   
function init() {
    var x = 0;
    console.log(x); // 0
} 
init(); 
console.log(x);  // 1
*/

/*
var x = 1; 
var x; 
function init() {
    x = 0;
    console.log(x); // 0
} 
init(); 
console.log(x); // 0
*/


var x = 1; 
{ 
    var x = 3; 
    function setValue() 
    { 
        var x = 5; 
        console.log(x);  // 3 
    } 
    console.log(x);  // 5
} 
setValue(); 
console.log(x); // 3

/*
var x = 1;   
var x; 
n = 5;  
function init() { 
    var x = 0; 
    var y = 2;   
    var z = 3;       
    n  = -1; 
    console.log(x); // 0
} 
init(); 
console.log(x);  // 1
console.log(y);  // y is not defined
console.log(z);  // z is not defined
console.log(n); // -1
*/