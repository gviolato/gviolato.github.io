d3.xml("./desenhos/diagrama_completo.svg", "image/svg+xml", 
       function(xml) {
	   var importedNode = document.importNode(xml.documentElement, true);
	   d3.select("#viz").node().appendChild(importedNode);
	   
	   d3.select("#vane_ponta")
	       .on("mouseover",function(){d3.select(this).style("fill","red");})
	       .on("mouseout",function(){d3.select(this).style("fill","black");})
	       .on("click", function() { apresentaMedicao(); } );
	   d3.select("#vane_aleta")
	       .on("mouseover",function(){d3.select(this).style("fill","red");})
	       .on("mouseout",function(){d3.select(this).style("fill","black");})
	       .style("cursor","pointer")
	       .call(drag);
	   d3.select("#ima")
	       .on("click", function(){ optsCallBack(0);});
	   d3.select("#globo")
	       .on("click", function(){ optsCallBack(1);} )
	   grayOut("#globo")
       });

var drag = d3.behavior.drag()
    .on("drag",rotaciona);


function optsCallBack(o) {
    
    var elem_coord = ["graus","minutos","segundos"];
    
    if (o==0) {
	grayOut("#globo");
	colorBack("#ima");
	d3.select("#opcao")
	    .attr("value","0");
	d3.select("#lat").remove();
	d3.select("#lon").remove();
	d3.select("#declinacao")
	    .attr("readonly",null)
	    .style("background-color",null);
    } else {
	grayOut("#ima");
	colorBack("#globo");
	d3.select("#opcao")
	    .attr("value","1");
	d3.select("#coords")
	    .append("div")
	    .attr("id","lat")
	    .append("label")
	    .attr("for","latitude")
	    .text("Latitude (S):");
	d3.select("#lat").selectAll("input")
	    .data(elem_coord).enter()
	    .append("input")
	    .attr("class","coordenada")
	    .attr("type","number")
	    .attr("id",function(d) { return "lat_" + d; })
	    .attr("value","0");
	d3.select("#coords")
	    .append("div")
	    .attr("id","lon")
	    .append("label")
	    .attr("for","longitude")
	    .text("Longitude (W):");
	d3.select("#lon").selectAll("input")
	    .data(elem_coord).enter()
	    .append("input")
	    .attr("class","coordenada")
	    .attr("type","number")
	    .attr("id",function(d) { return "lon_" + d; })
	    .attr("value","0");
	d3.select("#declinacao")
	    .attr("readonly","true")
	    .style("background-color","#BBB");
    }
    
}

function rotaciona(d) {

    var info = compilaDadosForm();

    var x = d3.mouse(document.getElementById("canvas"))[0];
    var y = d3.mouse(document.getElementById("canvas"))[1];
    
    pabs_x = info.pvx + 279;
    pabs_y = info.pvy + 279;

    var rot_a = R2D(Math.atan2( y - pabs_y , x - pabs_x )) - 90;

    d3.select("#vane")
	.attr("transform",
	      "translate("+info.pvx.toString()+","+info.pvy.toString()+") "+
	      "rotate("+rot_a.toString()+",279,279)");
    
    var dir_vento = ajustaAng(rot_a);
    var medido = ajustaAng(dir_vento - info.offset);
    
    if (d3.select("#medicao").empty()==false) {
	d3.select("#direcao")
	    .text("Direcao Vento: " + dir_vento.toFixed(1));
	d3.select("#medido")
	    .text("Medicao: " + medido.toFixed(1));
    }
}

d3.select("#botao_calcula")
    .on("mousedown", 
	function(d, i){
	    var decl_opt = Number(document.getElementById("opcao").getAttribute("value"));

	    if (decl_opt) {
		ngdcDeclination();
	    }
	    var info = compilaDadosForm();
	    
	    gira_obj("#norte_mag",info.delta);
	    gira_obj("#torre",info.ang_torre);
	    posiciona_vane(info);
	    apresentaOffset(info.offset);
	    /* De-seleciona e apaga as cotas */
	    d3.select("#cota1").remove();
	    d3.select("#cota2").remove();
	    d3.select("#cota3").remove();
	    document.getElementById("cotas").checked = false;
	});


d3.select("#cotas")
    .on("click", 
	function(d,i){
	    if (document.getElementById("cotas").checked == true) {
		var info = compilaDadosForm();
		createAngularDim("#canvas","cota1",getAngDim(110,info.delta,0,0,0),"gray");
		createAngularDim("#canvas","cota2",getAngDim(60,info.delta,info.ang_braco,0,0),"gray");
		createAngularDim("#canvas","cota3",getAngDim(30,info.offset,info.ang_braco+180,info.pvx,info.pvy),"red");
	    } else {
		d3.select("#cota1").remove();
		d3.select("#cota2").remove();
		d3.select("#cota3").remove();
	    }
	});


d3.select("#botao_download")
    .on("mouseover", function(d,i){
	
	var svg = document.getElementById("canvas");
	var svg_xml = (new XMLSerializer).serializeToString(svg);

        d3.select(this)
	    .attr("href-lang", "image/svg+xml")
            .attr("href", "data:image/svg+xml;base64,\n" + btoa(svg_xml));
    });

function ngdcDeclination() {

    var lat_d = gms2dec(readCoordForm("lat"));
    var lon_d = gms2dec(readCoordForm("lon"));

    var pathArr = window.location.href.split("/");
    pathArr.pop();
    var path = pathArr.join("/");

    var geoMag = geoMagFactory(cof2Obj(syncXHR(path + '/WMM.COF')));
    
    var myGeoMag = geoMag(lat_d,lon_d,0);

    document.getElementById("declinacao").value = myGeoMag.dec.toFixed(2);
    
}

function readCoordForm(id) {

    var res = new Object;
    
    res.graus = Number(document.getElementById(id+"_graus").value);
    res.minutos = Number(document.getElementById(id+"_minutos").value);
    res.segundos = Number(document.getElementById(id+"_segundos").value);

    return res;

}

function getAngDim(r,a1,a2,dx,dy) {

    if (a1>a2) {
	var aux = a1
	a1 = a2;
	a2 = aux;
    }

    return { "radius": r,
	     "ang_i": a1,
	     "ang_f": a2,
	     "dx": dx,
	     "dy": dy }

}

function createAngularDim(parent_id,dim_id,dims,cor) {


    var markers_data = ["S","E"];

    var m_height = 10.8;
    var m_base   =  3.6;

    var pts_m = [ { "x": 279, "y": 279},
		  { "x": 279-m_base/2, "y": 279+m_height},
                  { "x": 279+m_base/2, "y": 279+m_height},
		  { "x": 279, "y": 279} ];

    
    var value = dims.ang_f - dims.ang_i;
    if (value == 360) {
	value = 0;
	dims.ang_f = dims.ang_i;
    }

    var lineFunction = d3.svg.line()
        .x(function(d) { return d.x; })
        .y(function(d) { return d.y; })
        .interpolate("linear");
    
    var arc = d3.svg.arc()
    	.innerRadius(dims.radius - 0.5)
	.outerRadius(dims.radius + 0.5)
	.startAngle(D2R(dims.ang_i))
	.endAngle(D2R(dims.ang_f));
    
    d3.select(parent_id)
	.append("g")
	.attr("id",dim_id);

    var pos_x = 279 + dims.dx;
    var pos_y = 279 + dims.dy;
    d3.select("#"+dim_id)
	.append("path")
	.attr("d", arc)
	.attr("id","arco")
    	.attr("stroke","none")
	.attr("fill",cor)
	.attr("transform","translate("+pos_x.toString()+
	      ","+pos_y.toString()+")");
    
    var angV = dims.ang_i + value/2 + 4;
    var dxV = dims.dx + (dims.radius+5)*Math.sin(D2R(angV- 10/dims.radius*180/Math.PI));
    var dyV = dims.dy -1*(dims.radius+5)*Math.cos(D2R(angV- 10/dims.radius*180/Math.PI));
    d3.select("#"+dim_id)
	.append("text")
	.attr("x",279)
	.attr("y",279)
	.style("font-size","10pt")
	.style("fill",cor)
	.text(value.toFixed(1))
	.attr("transform",
	      "translate("+dxV.toString()+","+dyV.toString()+") "+
	      "rotate("+angV.toString()+",279,279)");

    var dxS = dims.dx + dims.radius*Math.sin(D2R(dims.ang_i));
    var dyS = dims.dy - dims.radius*Math.cos(D2R(dims.ang_i));
    var dxE = dims.dx + dims.radius*Math.sin(D2R(dims.ang_f));
    var dyE = dims.dy - dims.radius*Math.cos(D2R(dims.ang_f));
    var angS = dims.ang_i-90+R2D(m_height/dims.radius/2);
    var angE = dims.ang_f+90-R2D(m_height/dims.radius/2);

    d3.select("#"+dim_id)
	.append("g").attr("id","markers").selectAll("path")
	.data(markers_data).enter()
	.append("path")
	.attr("d", lineFunction(pts_m))
	.attr("id", function(d) { return "marker_"+d; })
	.attr("stroke","none")
	.attr("fill",cor);

    d3.select("#"+dim_id+" #marker_S")
	.attr("transform",
	      "translate("+dxS.toString()+","+dyS.toString()+") "+
	      "rotate("+angS.toString()+",279,279)");
    d3.select("#"+dim_id+" #marker_E")
	.attr("transform",
	      "translate("+dxE.toString()+","+dyE.toString()+") "+
	      "rotate("+angE.toString()+",279,279)");

}

function apresentaMedicao() {

    if ( d3.select("#medicao").empty() ) {
	d3.select("#canvas")
	    .append("text")
	    .attr("xml:space","preserve")
	    .style("font-size","7.5pt")
	    .style("font-family","Courier")
	    .style("text-align","end")
	    .style("text-ancor","end")
	    .attr("x","438")
	    .attr("y","18")
	    .attr("id","medicao")
	    .attr("sodipodi:linespacing","125%");

	d3.select("#medicao")
	    .append("tspan")
	    .attr("sodipode:role","line")
	    .attr("id","direcao")
	    .attr("x","438")
	    .attr("y","18")
	    .text("Direcao Vento:");

	d3.select("#medicao")
	    .attr("sodipode:role","line")
	    .append("tspan")
	    .attr("id","medido")
	    .attr("x","438")
	    .attr("y","36")
	    .text("Medicao:");
    } else {
	d3.select("#medicao").remove();
    }
}

function apresentaOffset(offset) {

    var off_replementar = offset-360;

    d3.select("#resposta")
	.style("font-family","Serif")

    d3.select("#resposta")
	.select("#linha1")
	.text("Offset: +" + offset.toFixed(1));
    d3.select("#resposta")
	.select("#linha2")
	.text("ou: " + off_replementar.toFixed(1));

}

function gira_obj(nome,ang) {

    d3.select(nome)
	.transition()
	.attr("transform",
	      "rotate(" + ang.toString() + ",279,279)");
    
}

function posiciona_vane(info) {

    d3.select("#vane")
	.transition()
	.attr("transform",
	      "translate("+info.pvx.toString()+","+info.pvy.toString()+")");
    d3.select("#zero_vane")
	.transition()
	.attr("transform",
	      "translate("+info.pvx.toString()+","+info.pvy.toString()+") "+ 
	      "rotate("+info.offset.toString()+",279,279)");
}

function compilaDadosForm() {

    var angulos = ["declinacao", "ang_haste", "ang_barbante"];
    var dados = new Object();

    for(var i=0; i<angulos.length; i++) {
	dados[angulos[i]] = document.getElementById(angulos[i]).value;
    }

    var braco = 234;

    var info = new Object;
    info.gamma = Number(dados["ang_haste"]);
    info.delta = Number(dados["declinacao"]);
    info.beta  = Number(dados["ang_barbante"]);
    info.lado  = getRadioValue("lado");


    info.ang_braco = info.gamma + info.delta;

    info.offset =  ajustaAng(info.ang_braco - info.beta);

    info.ang_torre = 0;
    if (info.lado=="D")
	info.ang_torre = 90 + info.ang_braco;
    else
	info.ang_torre = info.ang_braco - 90;

    info.pvx = -braco*Math.cos(D2R(info.ang_braco + 90));
    info.pvy = -braco*Math.sin(D2R(info.ang_braco + 90));
    
    return info;
    
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


function grayOut(objid) {

    d3.select(objid)
	.style("-webkit-filter", "grayscale(100%)")
	.style("-moz-filter", "grayscale(100%)")
	.style("-o-filter", "grayscale(100%)")
	.style("-ms-filter", "grayscale(100%)")
	.style("filter", "grayscale(100%)");

}

function colorBack(objid) {

    d3.select(objid)
	.attr("style",null)

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

function R2D(ang) {

    return ang*180/Math.PI;

}

function gms2dec(coord) {
    
    var res = Math.abs(coord.graus);
    res = res + Math.abs(coord.minutos)/60;
    res = res + Math.abs(coord.segundos)/3600;
    
    return  invsign(coord.graus)*res;

}

function invsign(num) {
    
    if (Math.abs(num)==num) {
	return -1;
    } else {
	return 1;
    }

}
