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
//
// Data:
//
// ----------------------------- PARÂMETROS ------------------------------------

// Configuração do projeto:
projeto.implantacao = 1;                //Prazo de implantação do projeto (meses)
projeto.vida_util = 20*12;              //Vida útil operacional do projeto (meses)
projeto.potencia = 0.9;                 //Potência instalada (MW)
projeto.vel_media = 6.0;                //Velocidade média anual de vento (m/s)
projeto.regime = 2;                     //Regime de produção de energia [1-Produção independente;
                                        //2-Sistema de compensação de energia; 3-Autoprodução]
projeto.preco_energia = 237;            //Preço da energia (R$/MWh)
projeto.modelo_PAE = 1;                 //Modelo para determinação da produção anual de energia
                                        //[1-Função get_PAE
                                        //2-Produção anual de energia como parâmetro de entrada
                                        //3-Fator de capacidade do parque como parâmetro de entrada]
projeto.PAE = 2969;                     //Produção anual de energia do parque eólico (MWh/ano)
projeto.consumidor = %t;                //Considerar modelagem da conta do consumidor? [%t-Sim; %f-Não]
projeto.fator_capacidade = 0.40;        //Fator de capacidade do parque eólico (MWh/ano)
projeto.modelo_CAPEX = 2;               //Modelo para determinação do CAPEX
                                        //[1-NREL,"Wind Turbine Design Cost and Scaling Model";
                                        //2-Custo do MW instalado como parâmetro de entrada]
projeto.custo_MW = 2.45e6/(0.9*0.7);    //Custo do MW instalado (R$/MW)
projeto.TMA = 0.10;                     //Taxa de mínima atratividade do investidor (a.a.)

// Configuração da conta do consumidor:
conta.tarifa_ponta = 332.322+924.517;   //Tarifa energia elétrica ponta (R$/MWh)
conta.tarifa_f_ponta = 200.279+54.966;  //Tarifa energia elétrica fora de ponta (R$/MWh)
conta.tarifa_demanda = 10.226553;       //Tarifa demanda (R$/kW)
conta.tarifa_demanda_ultr = 20.453019;  //Tarifa adicional demanda ultrapassada (R$/kW)
conta.consumo_ponta = 4.1;              //Consumo médio energia elétrica ponta (MWh)
conta.consumo_f_ponta = 150.325;        //Consumo médio energia elétrica fora de ponta (MWh)
conta.demanda_contratada = 600;         //Demanda contratada(kW)
conta.demanda_ultr = 187.1;             //Demanda ultrapassada média (kW)

// Configuração da turbina:
turbina.diametro_rotor = 54;            //Diâmetro do rotor (m)
turbina.potencia_nominal = 900;         //Potência nominal do gerador (kW)
turbina.torque_eixo = 370;              //Máximo torque aerodinâmico no eixo do rotor (kNm)
turbina.altura_hub = 75;                //Altura do hub (m)
turbina.fator_correcao_gerador = 3/2.38 //Fator de correção de massa do gerador, para turbina EWT
turbina.conceito = 4;                   //Conceito da turbina [1-Three-Stage Drive with High-Speed Generator;
                                        //2-Single-Stage Drive with Medium-Speed, Permanent-Magnet Generator;
                                        //3-Multi-Path Drive with Multiple Permanent-Magnet Generators;
                                        //4-Direct Drive]
turbina.modelo = 1;                     //Modelo da turbina [1-FEEl 900kW]

// Financiamento:
// Referência - http://www.bndes.gov.br/SiteBNDES/bndes/bndes_pt/Institucional/Apoio_Financeiro/Produtos/FINEM/energias_alternativas.html
financiamento.percentual = 0.75;//0.80;     //Parcela do investimento total financiada
financiamento.prazo = 16*12;            //Prazo do fianciamento (meses)
financiamento.carencia = 6;             //Carência do financiamento (meses)
financiamento.TJLP = 0.02;//0.05;           //Taxa nominal de juros de longo prazo - TJLP (a.a.)
financiamento.spread_basico = 0.01;//0.009; //Spread básico (a.a.)
financiamento.spread_risco = 0.01;   //Spread de risco (a.a.)

// Impostos:
impostos.PIS_PASEP = 0.0165;            //PIS/PASEP sobre a receita bruta
impostos.COFINS = 0.076;                //COFINS sobre a receita bruta
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
custos.BETU = 484.21e3/12               //Benefício Econômico Típico Unitário mensal (R$/MW)
                                        //em 2012 = 418.39e3/12
                                        //em 2013 = 484.21e3/12 - Ref http://www.aneel.gov.br/cedoc/ndsp2013101.pdf
custos.administrativos = 0.005;         //Custos administrativos, sobre a receita bruta
