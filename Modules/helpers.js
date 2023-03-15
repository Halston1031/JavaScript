function $g(selector){
    let nodelist = document.querySelectorAll(selector); 
    if(nodelist.length == 0)
    { 
        return null;     
    } 
    return nodelist.length == 1 ? nodelist[0] : nodelist; 
} 
export { $g }; 