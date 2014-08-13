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
// Estudo de caso para site da NOTUS em Guarapuava, considerando 30 turbinas
// FEEL 900kW. Solicitado por Gilmar Mercs.
//
// Data: 26/04/2013
//
// ----------------------------- PARÂMETROS ------------------------------------

// Configuração do projeto:
projeto.implantacao = 1;                //Prazo de implantação do projeto (meses)
projeto.vida_util = 20*12;              //Vida útil operacional do projeto (meses)
projeto.potencia = 30*0.9;              //Potência instalada (MW)
projeto.vel_media = 7.0;                //Velocidade média anual de vento (m/s)
projeto.regime = 3;                     //Regime de produção de energia [1-Produção independente;
                                        //2-Sistema de compensação de energia; 3-Autoprodução]
projeto.preco_energia = 304;            //Preço da energia (R$/MWh)
projeto.modelo_PAE = 1;                 //Modelo para determinação da produção anual de energia
                                        //[1-Função get_PAE
                                        //2-Produção anual de energia como parâmetro de entrada
                                        //3-Fator de capacidade do parque como parâmetro de entrada]
projeto.PAE = 2969;                     //Produção anual de energia do parque eólico (MWh/ano)
projeto.consumidor = %f;                //Considerar modelagem da conta do consumidor? [%t-Sim; %f-Não]
projeto.fator_capacidade = 0.14;        //Fator de capacidade do parque eólico (MWh/ano)
projeto.modelo_CAPEX = 2;               //Modelo para determinação do CAPEX
                                        //[1-NREL,"Wind Turbine Design Cost and Scaling Model";
                                        //2-Custo do MW instalado como parâmetro de entrada]
projeto.custo_MW = 2.3e6/(0.9*0.7);     //Custo do MW instalado (R$/MW)
projeto.TMA = 0.08;                     //Taxa de mínima atratividade do investidor (a.a.)

// Configuração das perdas de energia no parque eólico:
// Referência - EWEA, The Economics of Wind Energy, p. 55, 2009
perdas.array = 0.05;                    //Array losses, perdas aerodinâmicas por sombreamento de turbinas,
                                        //turbulência, etc. Tipicamente 5-10%, menor em caso de turbina isolada
perdas.soiling = 0.015;                 //Perdas aerodinâmicas por sujeira nas pás, tipicamente 1-2%
perdas.grid = 0.02;                     //Perdas elétricas na rede do parque eólico, tipicamente 1-3%
perdas.downtime = 0.02;                 //Perdas por indisponibilidade da turbina, tipicamente 2%
perdas.other = 0.01;                    //Outras perdas, como atrasos no acionamento do yaw. Tipicamente 1%

// Configuração da conta do consumidor:
// Referência tarifas: http://www.copel.com/hpcopel/root/nivel2.jsp?endereco=%2Fhpcopel%2Froot%2Fpagcopel2.nsf%2F5d546c6fdeabc9a1032571000064b22e%2F0a363cf546237cc203257488005939ce
conta.tarifa_ponta = 1000.16;           //Tarifa energia elétrica ponta (R$/MWh)
conta.tarifa_f_ponta = 204.99;          //Tarifa energia elétrica fora de ponta (R$/MWh)
conta.tarifa_demanda = 7.81;            //Tarifa demanda (R$/kW)
conta.tarifa_demanda_ultr = 15.63;      //Tarifa adicional demanda ultrapassada (R$/kW)
conta.consumo_ponta = 40*4.1;           //Consumo médio energia elétrica ponta (MWh)
conta.consumo_f_ponta = 40*150.325;     //Consumo médio energia elétrica fora de ponta (MWh)
conta.demanda_contratada = 40*600;      //Demanda contratada(kW)
conta.demanda_ultr = 40*187.1;          //Demanda ultrapassada média (kW)

// Configuração da turbina:
turbina.diametro_rotor = 54;            //Diâmetro do rotor (m)
turbina.potencia_nominal = 900;         //Potência nominal do gerador (kW)
turbina.altura_hub = 75;                //Altura do hub (m)
turbina.modelo_torque = 2;              //Modelo para determinação do máximo torque
                                        //aerodinâmico no eixo do rotor
                                        //[1-Calculado através da potência, rotação e eficiência nominais;
                                        //2-Como parâmetro de entrada]
turbina.rotacao_nominal = 15.75;        //Rotação nominal (rpm), informação utilizada no cálculo do torque
turbina.eficiencia = 0.925;             //Eficiência do sistema eletro-mecânico, do eixo principal
                                        //à saída do conversor (informação utilizada no cálculo do torque)
turbina.torque_eixo = 370;              //Máximo torque aerodinâmico no eixo do rotor (kNm)
turbina.fator_correcao_gerador = 3/2.38 //Fator de correção de massa do gerador, para turbina EWT
turbina.fator_correcao_custo = 1.4      //Fator de correção de custo, para turbina EWT
turbina.conceito = 4;                   //Conceito da turbina [1-Three-Stage Drive with High-Speed Generator;
                                        //2-Single-Stage Drive with Medium-Speed, Permanent-Magnet Generator;
                                        //3-Multi-Path Drive with Multiple Permanent-Magnet Generators;
                                        //4-Direct Drive]
turbina.modelo = 1;                     //Modelo da turbina [1-FEEl 900kW]
                                        //(informação utilizada na função get_PAE)

// Financiamento:
// Referência - http://www.bndes.gov.br/SiteBNDES/bndes/bndes_pt/Institucional/Apoio_Financeiro/Produtos/FINEM/energias_alternativas.html
financiamento.percentual = 0.80;        //Parcela do investimento total financiada
financiamento.prazo = 16*12;            //Prazo do fianciamento (meses)
financiamento.carencia = 18;            //Carência do financiamento (meses)
financiamento.TJLP = 0.05;              //Taxa nominal de juros de longo prazo - TJLP (a.a.)
financiamento.spread_basico = 0.009;    //Spread básico (a.a.)
financiamento.spread_risco = 0.01;      //Spread de risco (a.a.)

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
