// -----------------------------------------------------------------------------
// AVEEL Software
// Análise de Viabilidade de Empreendimentos Eólicos
// 
// Autor: Júlio Xavier Vianna Neto
// 
// Tarefas:
// 1-Arrumar prazo de carência iniciando no primeiro aporte
// 2-ICMS no sitema de compensação e autoprodução
// 3-Inserir CCC e ESS
// 
// -----------------------------------------------------------------------------

//Inicialização do ambiente:
clc
xdel(winsid()) //Equivalente de close all
clear
pathname = get_absolute_file_path('AVEEL.sce');
chdir(pathname);

//Carregamento de funções externas:
exec('get_custos_implantacao.sce',-1)
exec('get_PAE.sci',-1)
exec('payback.sci',-1)
exec('tir.sci',-1)
exec('xls_SelectWorksheet.sci',-1)
atomsLoad("xls_link");


// --------------------- LEITURA DOS PARÂMETROS DO USUÁRIO ---------------------

//Seleção do arquivo de parâmetros
[arquivo,pasta] = uigetfile('*.sc*',pathname,'Selecione o arquivo de parâmetros');

if isempty(arquivo) then
    abort;
end

exec(strcat([pasta '\' arquivo]),-1);


// --------------------- INICIALIZAÇÃO DO ARQUIVO DE SAÍDA ---------------------

arquivo_xls = strcat([pasta '\Resultados ' part(arquivo, 1:length(arquivo)-3) 'xls']);
if isfile(arquivo_xls) then
    deletefile(arquivo_xls);
end
if verbose then
    copyfile('Template.xls', arquivo_xls);
end


// ---------------------- FLUXO DE CAIXA DE INVESTIMENTOS ----------------------

//Numeração dos meses
mes = [0:projeto.implantacao+projeto.vida_util-1]';

//      - Investimento total do projeto (CAPEX) ................................
flag_operacao = mes >= projeto.implantacao;  //Indica quando está em operação
if projeto.modelo_CAPEX == 1 then
    custo_MW_instalado = get_custos_implantacao(turbina,verbose,arquivo_xls);  //Custo do MW instalado (CAPEX/MW)
else
    custo_MW_instalado = projeto.custo_MW;  //Custo do MW instalado (CAPEX/MW)
end
investimento_total = -custo_MW_instalado*projeto.potencia/projeto.implantacao*~flag_operacao;

//      + Financiamento recebido ................................................
recurso_financiamento = -investimento_total*financiamento.percentual;
//OBSERVAÇÕES: Como é feita na prática a disponibilização de recursos de
//financiamento? Em parcelas fixas? O financiamento é sobre a turbina ou sobre
//o investimento total?

//      = Fluxo de caixa dos investimentos .....................................
FC_investimentos = investimento_total + recurso_financiamento;


// ------------------------ DEMONSTRATIVO DE RESULTADOS ------------------------

//      + Receita bruta mensal .................................................
//Produção de energia mensal (MWh/mês)
select projeto.modelo_PAE
case 1 //Função get_PAE
    producao_bruta = get_PAE(turbina.modelo,projeto.vel_media)/12*projeto.potencia/(turbina.potencia_nominal*1e-3);
case 2 //Produção anual de energia como parâmetro de entrada
    producao_bruta = projeto.PAE/12;
case 3 //Fator de capacidade do parque como parâmetro de entrada
    producao_bruta = projeto.potencia*projeto.fator_capacidade*24*30;
end

//Perdas
coeficiente_perdas = (1 - perdas.array)*(1 - perdas.soiling)*(1 - perdas.grid)*(1 - perdas.downtime)*(1 - perdas.other);
producao = producao_bruta*coeficiente_perdas;

if projeto.regime ~= 1 & projeto.consumidor then    //Modelo de conta do consumidor (somente nos
                                                    //casos de sistema de compensação e autoprodução)
    if producao > (conta.consumo_ponta + conta.consumo_f_ponta) then
        disp('Produção maior que consumo!');
    end
    
    //Média ponderada das tarifas de ponta e fora de ponta
    tarifa = (conta.consumo_ponta*conta.tarifa_ponta + conta.consumo_f_ponta*conta.tarifa_f_ponta)/(conta.consumo_ponta + conta.consumo_f_ponta);
    
    //Alterações na conta devido à geração
    consumo = min(producao,conta.consumo_ponta + conta.consumo_f_ponta)*tarifa;
    if projeto.regime == 2 then //Se for sistema de compensação, a potência instalada é limitada à demanda contratada
        demanda = -max(projeto.potencia*1e3 - conta.demanda_contratada,0)*conta.tarifa_demanda;
        demanda_ultr = min(conta.demanda_ultr,max(projeto.potencia*1e3 - conta.demanda_contratada,0))*(conta.tarifa_demanda + conta.tarifa_demanda_ultr);
    else
        demanda = 0;
        demanda_ultr = 0;
    end
    
    //Economia gerada é considera como receita bruta
    receita_bruta = (consumo + demanda + demanda_ultr)*flag_operacao;
    
else    //Modelo de venda de energia
    receita_bruta = producao*projeto.preco_energia*flag_operacao;  //Retirar fator 8640/8760 !!!!!!!!!!!!
end

//      - Tributos sobre a receita .............................................
if projeto.regime == 1 then  //Se for produção independente
    PIS_PASEP = -impostos.PIS_PASEP*receita_bruta;
    COFINS = -impostos.COFINS*receita_bruta;
else
    PIS_PASEP = 0*flag_operacao;
    COFINS = 0*flag_operacao;
end
//OBSERVAÇÕES: Existe desconto de 10%? Qual é o crédito do PIS e COFINS
//proveniente da implantação do parque eólico?

//      = Receita líquida mensal ...............................................
receita_liquida = receita_bruta + PIS_PASEP + COFINS;

//      - Custos operacionais ..................................................
if projeto.regime == 2 then  //Se não for sistema de compensação de energia
    custos.seguro = 0;
    custos.TUST = 0;
    custos.conexao = 0;
    custos.TFSEE = 0;
    custos.terreno = 0;
end
custos_fixos = -custos.OeM*projeto.potencia*flag_operacao + custos.seguro*sum(investimento_total)*flag_operacao...
    - custos.TUST*projeto.potencia*flag_operacao - custos.conexao*projeto.potencia*flag_operacao...
    - custos.TFSEE*custos.BETU*projeto.potencia*flag_operacao;
custos_variaveis = -custos.administrativos*receita_bruta - custos.terreno*receita_bruta;
//OBSERVAÇÕES:
// 1 - A TFSEE deve ser cobrada sobre o MW instalado.
// 2 - A TUST é paga pelo produtor?
// 3 - O que são esses custos de conexão?

//      = EBITDA - Lucros antes de juros, impostos, depreciação
//      e amortização ..........................................................
EBITDA = receita_liquida + custos_fixos + custos_variaveis;

//      - Depreciação ..........................................................
depreciacao = sum(investimento_total)/projeto.vida_util*flag_operacao;
//OBSERVAÇÕES: A depreciação é considerada sobre todo o investimento inicial,
//ou somente sobre a turbina (provavelmente sobre o valor total)? A depreciação
//é linear?

//      - Juros ................................................................
//Amortização
flag_amortizacao = (mes >= projeto.implantacao + financiamento.carencia) & ...
(mes < projeto.implantacao + financiamento.carencia + financiamento.prazo);
amortizacao = -sum(recurso_financiamento)/financiamento.prazo*flag_amortizacao;

//Taxa de juros mensal
taxa_juros = (1 + financiamento.TJLP + financiamento.spread_basico + financiamento.spread_risco)^(1/12) - 1;

saldo_devedor = zeros(length(mes),1);
juros = zeros(length(mes),1);
for m = 2:length(mes)
    saldo_devedor(m) = saldo_devedor(m-1) - recurso_financiamento(m-1) - amortizacao(m-1);
    juros(m) = saldo_devedor(m)*taxa_juros;
end
//OBSERVAÇÕES: Como é feito o pagamento de juros no período de carência/implantação?

//      = LAIR (ou EBT) - Lucro antes do imposto de renda ......................
LAIR = EBITDA + depreciacao + juros;

//      - Tributos sobre o lucro, i.e., Imposto de Renda e CSLL ................
if projeto.regime == 1 then //Se for produção independente
    IR = -max(impostos.IR*LAIR,0) - max(LAIR - impostos.limite_IR_adicional,0)*impostos.IR_adicional;
    CSLL = -max(impostos.CSLL*LAIR,0);
else
    IR = -max((impostos.IR + impostos.IR_adicional)*LAIR,0);
    CSLL = -max(impostos.CSLL*LAIR,0);
end
//OBSERVAÇÕES: No caso de autoprodução ou sistema de compensação de energia, os
//tributos sobre o lucro devem ser considerados sobre o incremento de lucro na
//atividade principal do consumidor, devido à redução das despesas com energia.

//      = Lucro líquido ........................................................
lucro_liquido = LAIR + IR + CSLL;


// ----------------------- FLUXO DE CAIXA DO INVESTIDOR ------------------------

//      + Lucro líquido ........................................................

//      - Amortização ..........................................................

//      + Valores não desembolsados (depreciação) ..............................
nao_desembolsados = -depreciacao;

//      - Investimento próprio .................................................

//      = Fluxo de caixa nominal do investidor .................................
FC_investidor = lucro_liquido + amortizacao + nao_desembolsados + FC_investimentos;

//TMA mensal
TMA = (1 + projeto.TMA)^(1/12) - 1;

//WACC - Weighted average cost of capital (a.m.)
//WACC = (sum(-FC_investimentos)*projeto.TMA + sum(recurso_financiamento)*(financiamento.TJLP + ...
//    financiamento.spread_basico + financiamento.spread_risco))/sum(-investimento_total);
//WACC = (1 + WACC)^(1/12) - 1;

FC_investidor_descontado = FC_investidor./(1 + TMA).^mes;


// --------------------------- FLUXO DE CAIXA LIVRE ----------------------------

//      + Lucro líquido ........................................................

//      + Valores não desembolsados (depreciação) ..............................

//      + Juros ................................................................

//      - Investimento total (CAPEX) ...........................................

//      = Fluxo de caixa livre nominal .........................................
FC_livre = lucro_liquido + nao_desembolsados - juros + investimento_total;

//Fluxo de caixa descontado
FC_livre_descontado = FC_livre./(1 + TMA).^mes;


// ------------------------- INDICADORES DE RESULTADO --------------------------

//Fator de capacidade
fator_capacidade = producao/(projeto.potencia*24*30);

mprintf('----- INDICADORES DE RESULTADO -----\n\n\n')

mprintf('..... Viabilidade do investidor .....\n\n')

//Taxa Interna de Retorno
TIR_investidor = (1 + tir(FC_investidor))^12 - 1;
mprintf('Taxa Interna de Retorno:   %.2f%% a.a.\n\n',TIR_investidor*100)

//Valor Presente Líquido
VPL_investidor = sum(FC_investidor_descontado);
mprintf('Valor Presente Líquido:    R$ %.2f\n\n',VPL_investidor)

//Payback simples
PB_simples_investidor = payback(FC_investidor);
mprintf('Payback simples:           %i meses\n\n',PB_simples_investidor)

//Payback descontado
PB_descontado_investidor = payback(FC_investidor_descontado);
mprintf('Payback descontado:        %i meses\n\n\n',PB_descontado_investidor)


mprintf('...... Viabilidade do projeto .......\n\n')

//Taxa Interna de Retorno
TIR_livre = (1 + tir(FC_livre))^12 - 1;
mprintf('Taxa Interna de Retorno:   %.2f%% a.a.\n\n',TIR_livre*100)

//Valor Presente Líquido
VPL_livre = sum(FC_livre_descontado);
mprintf('Valor Presente Líquido:    R$ %.2f\n\n',VPL_livre)

//Payback simples
PB_simples_livre = payback(FC_livre);
mprintf('Payback simples:           %i meses\n\n',PB_simples_livre)

//Payback descontado
PB_descontado_livre = payback(FC_livre_descontado);
mprintf('Payback descontado:        %i meses\n\n',PB_descontado_livre)


// ----------------------------- ARQUIVO DE SAÍDA ------------------------------

if verbose then
    xls_NewExcel();
    // set visible excel windows
    xls_SetVisible(%f);
    xls_Open(arquivo_xls);
    // disable some excel messagebox
    xls_DisplayAlerts(%f);
    
    //previous_mode = mode();
    //mode(7);
    
    xls_SelectWorksheet('Configuração do Projeto');
    xls_SetData("C2", projeto.implantacao);
    xls_SetData("C4", projeto.vida_util);
    xls_SetData("C6", projeto.potencia);
    xls_SetData("C7", turbina.potencia_nominal);
    select projeto.regime
    case 1
        xls_SetData("C9", 'Produção independente');
    case 2
        xls_SetData("C9", 'Sistema de compensação de energia');
    case 3
        xls_SetData("C9", 'Autoprodução');
    end
    xls_SetData("C10", projeto.TMA);
    xls_SetData("C12", custo_MW_instalado);
    if projeto.regime ~= 1 & projeto.consumidor then    //Modelo de conta do consumidor (somente nos
                                                        //casos de sistema de compensação e autoprodução)
        xls_SetData("C13", 'Ver planilha ''Conta do Consumidor''');
    else
        xls_SetData("C13", projeto.preco_energia);
    end
    
    xls_SelectWorksheet('Análise de Viabilidade');
    xls_SetData("C7", sum(investimento_total));
    xls_SetData("C8", TIR_livre);
    xls_SetData("C10", VPL_livre);
    xls_SetData("C11", PB_simples_livre);
    xls_SetData("C13", PB_descontado_livre);
    xls_SetData("F7", sum(FC_investimentos));
    xls_SetData("F8", TIR_investidor);
    xls_SetData("F10", VPL_investidor);
    xls_SetData("F11", PB_simples_investidor);
    xls_SetData("F13", PB_descontado_investidor);
    
    if projeto.modelo_CAPEX ~= 1 then
        xls_SelectWorksheet('Custos da Turbina (Modelo NREL)');
        xls_DeleteWorksheet();
    end
    
    xls_SelectWorksheet('Desempenho do Projeto');
    if projeto.modelo_PAE == 1 then
        xls_SetData("C2", [projeto.vel_media
                           turbina.altura_hub]);
    end
    xls_SetData("C5", producao_bruta);
    xls_SetData("C7", producao_bruta*(1 - coeficiente_perdas));
    xls_SetData("C9", [producao
                       fator_capacidade]);
    
    xls_SelectWorksheet('Perdas');
    xls_SetData("C2", [perdas.array
                       perdas.soiling
                       perdas.grid
                       perdas.downtime
                       perdas.other
                       coeficiente_perdas]);

    xls_SelectWorksheet('Custos Operacionais');
    xls_SetData("C2", [custos.OeM; custos.OeM*projeto.potencia
                       custos.terreno; custos.terreno*receita_bruta($)
                       custos.seguro; -custos.seguro*sum(investimento_total)
                       custos.TUST; custos.TUST*projeto.potencia
                       custos.conexao; custos.conexao*projeto.potencia
                       custos.TFSEE; custos.TFSEE*custos.BETU*projeto.potencia
                       custos.BETU
                       custos.administrativos; custos.administrativos*receita_bruta($)]);
    
    xls_SelectWorksheet('Financiamento');
    xls_SetData("C2", [financiamento.percentual
                       financiamento.prazo]);
    xls_SetData("C5", financiamento.carencia);
    xls_SetData("C7", financiamento.TJLP);
    xls_SetData("C9", financiamento.spread_basico);
    xls_SetData("C11", financiamento.spread_risco);
    
    xls_SelectWorksheet('Conta do Consumidor');
    if projeto.regime ~= 1 & projeto.consumidor then
        xls_SetData("C2", [conta.tarifa_ponta
                           conta.tarifa_f_ponta
                           conta.tarifa_demanda
                           conta.tarifa_demanda_ultr
                           conta.consumo_ponta
                           conta.consumo_f_ponta
                           conta.demanda_contratada
                           conta.demanda_ultr]);
    else
        xls_DeleteWorksheet();
    end
    
    xls_SelectWorksheet('Fluxo de Caixa');
    xls_SetData("I5", investimento_total');
    xls_SetData("I7", recurso_financiamento');
    xls_SetData("I10", FC_investimentos');
    xls_SetData("I15", receita_bruta');
    xls_SetData("I17", [(PIS_PASEP + COFINS)'; PIS_PASEP'; COFINS']);
    xls_SetData("I22", receita_liquida');
    xls_SetData("I24", custos_fixos' + custos_variaveis');
    xls_SetData("I27", EBITDA');
    xls_SetData("I30", depreciacao');
    xls_SetData("I32", juros');
    xls_SetData("I35", LAIR');
    xls_SetData("I38", IR');
    xls_SetData("I40", CSLL');
    xls_SetData("I43", LAIR');
    xls_SetData("I51", amortizacao');
    xls_SetData("I58", FC_investidor');
    xls_SetData("I60", FC_investidor_descontado');
    xls_SetData("I74", FC_livre');
    xls_SetData("I76", FC_livre_descontado');
    
    //mode(previous_mode);
    
    xls_SetWorksheet(1);
    xls_Save();
    xls_Close();
    xls_Quit();
    
    winopen(arquivo_xls);
end
