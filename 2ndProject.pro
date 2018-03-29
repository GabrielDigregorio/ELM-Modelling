Include "2ndProject_GUI.pro";
//If(physicalmodel==1)
//Include "magnetic.pro"
//Else
Include "electric.pro"
//EndIf



// le switch ne marche pas, car apparement il reste bloqué sur le premier model .pro chargé . Il y a
// donc des soucis pour des variabels qui dsparaissent lorsque le swtich est utilisé.
