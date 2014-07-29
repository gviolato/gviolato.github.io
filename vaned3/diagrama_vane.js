d3.xml("./desenhos/diagrama_completo.svg", "image/svg+xml", 
       function(xml) {
	   var importedNode = document.importNode(xml.documentElement, true);
	   d3.select("#viz").node().appendChild(importedNode);
       });

d3.select("#botao_calcula")
    .on("mousedown", 
	function(d, i){
	    var info = leDadosForm();

	    var gamma = Number(info["ang_haste"]);
	    var delta = Number(info["declinacao"]);
	    var beta  = Number(info["ang_barbante"]);

	    var offset =  ajustaAng(gamma + delta - beta);
	    var ang_torre = 0;
	    
	    if (info["lado"]=="D")
		ang_torre = 90 + gamma + delta;
	    else
		ang_torre = gamma + delta - 90;
	    
	    gira_obj("#norte_mag",delta);
	    gira_obj("#torre",ang_torre);
	    posiciona_vane(ang_torre, beta, info["lado"]);
	    apresentaOffset(offset);
	});

function apresentaOffset(offset) {

    d3.select("#resposta").selectAll("p").remove();
    d3.select("#resposta")
	.append("p")
	.text("Offset: " + offset.toFixed(2) + " deg");

}

function gira_obj(nome,ang) {

    d3.select(nome)
	.transition()
	.attr("transform",
	      "rotate(" + ang.toString() + ",310,310)");
    
}

function posiciona_vane(ang, beta, lado) {
    
    var braco = 260;
    
    if (lado!="D")
	ang = ang + 180;

    var dx = -braco*Math.cos(D2R(ang));
    var dy = -braco*Math.sin(D2R(ang));

    var desal = ang-beta-90.;

    d3.select("#vane")
	.transition()
	.attr("transform",
	      "translate("+dx.toString()+","+dy.toString()+")");
    d3.select("#zero_vane")
	.transition()
	.attr("transform",
	      "translate("+dx.toString()+","+dy.toString()+") "+ 
	      "rotate("+desal.toString()+",310,310)");
}

function leDadosForm() {

    var angulos = ["declinacao", "ang_haste", "ang_barbante"];
    var dados = new Object();

    for(var i=0; i<angulos.length; i++) {
	dados[angulos[i]] = document.getElementById(angulos[i]).value;
    }
    dados["lado"] = getRadioValue("lado");

    return dados;

}

function getRadioValue(nome) {

    var radios = document.getElementsByName(nome);

    for (var i = 0, length = radios.length; i < length; i++) {
	if (radios[i].checked) {
            // do whatever you want with the checked radio
            return radios[i].value;	    
	}
    }
}


function ajustaAng(ang) {

    while( ang < 0 )
	ang = ang + 360;
    while( ang >= 360)
	ang = ang - 360;

    return ang;

}


function D2R(ang) {

    return ang*Math.PI/180;

}
