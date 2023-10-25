// RegExp emailRegax = RegExp(r'\S+@\S+\.\S+');
RegExp emailRegax = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

RegExp nameRegax = RegExp(r'^[a-z A-Z]+$');
// RegExp phoneNumberRegax =
//     RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
    RegExp phoneNumberRegax = RegExp(r'(^(?:[+0])?[0-9]{8,14}$)'); 
RegExp onlyNumberRegex = RegExp(r'^[0-9]+$');
