// -----------------------------------------------------------------------------
// AVEEL Software
// Análise de Viabilidade de Empreendimentos Eólicos
// Arquivo de parâmetros de entrada do usuário
// 
// Autor: Júlio Xavier Vianna Neto
// -----------------------------------------------------------------------------
//
// Descrição da simulação:
// 
// Estudo de caso considerando cenários dos últimos leilões. 12º Leilão de
// Energia Nova (Edital 02/2011 - Aneel)
//
// Data: 02/05/2013
//
// ----------------------------- PARÂMETROS ------------------------------------

verbose = %t;                           //Exportar resultados para Excel? [%t-Sim; %f-Não]

// Configuração do projeto:
projeto.implantacao = 1;                //Prazo de implantação do projeto (meses)
projeto.vida_util = 20*12;              //Vida útil operacional do projeto (meses)
projeto.potencia = 25;                  //Potência instalada (MW)
projeto.regime = 1;                     //Regime de produção de energia [1-Produção independente;
                                        //2-Sistema de compensação de energia; 3-Autoprodução]
projeto.preco_energia = 99.38;          //Preço da energia (R$/MWh)
projeto.modelo_PAE = 3;                 //Modelo para determinação da produção anual de energia
                                        //[1-Função get_PAE
                                        //2-Produção anual de energia como parâmetro de entrada
                                        //3-Fator de capacidade do parque como parâmetro de entrada]
projeto.consumidor = %f;                //Considerar modelagem da conta do consumidor? [%t-Sim; %f-Não]
projeto.fator_capacidade = 0.4515;      //Fator de capacidade do parque eólico (MWh/ano)
projeto.modelo_CAPEX = 2;               //Modelo para determinação do CAPEX
                                        //[1-NREL,"Wind Turbine Design Cost and Scaling Model";
                                        //2-Custo do MW instalado como parâmetro de entrada]
projeto.custo_MW = 3.5e6;//4011589.04;          //Custo do MW instalado (R$/MW)
projeto.TMA = 0.08;                     //Taxa de mínima atratividade do investidor (a.a.)

// Configuração das perdas de energia no parque eólico:
// Referência - EWEA, The Economics of Wind Energy, p. 55, 2009
perdas.array = 0;                       //Array losses, perdas aerodinâmicas por sombreamento de turbinas,
                                        //turbulência, etc. Tipicamente 5-10%, menor em caso de turbina isolada
perdas.soiling = 0;                     //Perdas aerodinâmicas por sujeira nas pás, tipicamente 1-2%
perdas.grid = 0;                        //Perdas elétricas na rede do parque eólico, tipicamente 1-3%
perdas.downtime = 0;                    //Perdas por indisponibilidade da turbina, tipicamente 2%
perdas.other = 0;                       //Outras perdas, como atrasos no acionamento do yaw. Tipicamente 1%

// Configuração da turbina:
turbina.potencia_nominal = 2500;        //Potência nominal do gerador (kW)

// Financiamento:
// Referência - http://www.bndes.gov.br/SiteBNDES/bndes/bndes_pt/Institucional/Apoio_Financeiro/Produtos/FINEM/energias_alternativas.html
financiamento.percentual = 0.80;        //Parcela do investimento total financiada
financiamento.prazo = 15*12;            //Prazo do fianciamento (meses)
financiamento.carencia = 24;            //Carência do financiamento (meses)
financiamento.TJLP = 0.05;              //Taxa nominal de juros de longo prazo - TJLP (a.a.)
financiamento.spread_basico = 0.009;    //Spread básico (a.a.)
financiamento.spread_risco = 0.01;      //Spread de risco (a.a.)

// Impostos:
impostos.PIS_PASEP = 0.0065;//0.0165;            //PIS/PASEP sobre a receita bruta
impostos.COFINS = 0.03;//0.076;                //COFINS sobre a receita bruta
impostos.CSLL = 0.09;                   //Contribuição social sobre o lucro líquido
impostos.IR = 0.15;                     //Imposto de Renda sobre o lucro
impostos.IR_adicional = 0.10;           //IR adicional sobre o excedente de R$20.000/mês
impostos.limite_IR_adicional = 20e3;    //Limite mensal do IR adicional

// Custos operacionais:
custos.OeM = 75e3/12;                   //Operação e manutenção (R$/MW/mês)
custos.terreno = 0.015;                 //Arrendamento do terreno, sobre a receita bruta
custos.seguro = 0.003/12;               //Seguro operacional por mês, sobre o investimento inicial
custos.TUST = 2.54e3;                   //Custo de transporte de energia, com desconto de 50% (R$/MW/mês)
custos.conexao = 500/12;                //Custo de conexão (R$/MW/mês)
custos.TFSEE = 0.004;                   //Taxa de Fiscalização de Serviços de Energia Elétrica - TFSEE, ANEEL, sobre benefício econômico
custos.BETU = 484.21e3/12;              //Benefício Econômico Típico Unitário mensal (R$/MW)
                                        //em 2012 = 418.39e3/12
                                        //em 2013 = 484.21e3/12 - Ref http://www.aneel.gov.br/cedoc/ndsp2013101.pdf
custos.administrativos = 0.005;         //Custos administrativos, sobre a receita bruta
