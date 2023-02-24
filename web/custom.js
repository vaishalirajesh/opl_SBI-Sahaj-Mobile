function customAlertMessage(msg){
const winUrl = URL.createObjectURL(

    new Blob([msg], { type: "text/html" })

);




const win =    window.open (winUrl, "_self");

   // alert(msg)

}