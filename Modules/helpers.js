function $g(selector){
    let nodelist = document.querySelectorAll(selector); 
    if(nodelist.length == 0)
    { 
        return null;     
    } 
    return nodelist.length == 1 ? nodelist[0] : nodelist; 
} 
//Create Element
function $ce(element, text) {
    let el = document.createElement(element);
    //判斷text參數是否合規?
    if (typeof(text) != "undefined" && text != "" && text != null) {
        el.innerHTML = text.trim();
    }

    return el;
}
export { $g, $ce};
