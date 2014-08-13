function PAE = get_PAE(turbina,v_media)
// Função para o cálculo da Produção Anual de Energia (PAE)
//
// Parâmetros de entrada:   turbina - Modelo da Turbina [1-FEEl 900kW]
//                          v_media - Velocidade média anual de vento no local (m/s)
// Parâmetro de saída:      PAE - Produção Anual de Energia (MWh/ano)
//
// Autor: Júlio Xavier Vianna Neto

select turbina,
    case 1  //FEEl 900kW
    //Informações de catálogo - para fator de forma de Weibull igual a 2
    wind_speed = [5.5 6.0 6.5 7.0 7.5];
    energy = [1581 1931 2285 2633 2969];
    
    PAE = interpln([wind_speed;energy],v_media);
    
    case 2  //Gamesa G144
    //Informações de catálogo - para fator de forma de Weibull igual a 2
    wind_speed = [5.5 6.0 6.5 7.0 7.5];
    energy = [5729 6709 7624 8465 9228];
    
    PAE = interpln([wind_speed;energy],v_media);
    
    case 3  //Northern 100-24
    //Informações de catálogo - para fator de forma de Weibull igual a 2
    wind_speed = [5.0 5.5 6.0 6.5 7.0];
    energy = [170 210 250 290 330];
    
    PAE = interpln([wind_speed;energy],v_media);
    
end

endfunction
