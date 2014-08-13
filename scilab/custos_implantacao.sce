//   -----------------------------------------------------------------
//   //-----//-----//   MODELAGEM DE PESOS E CUSTOS   \\-----\\-----\\
//   -----------------------------------------------------------------
//
//
// Autores: Rodrigo Canestraro Quadros                
//          Diogo Rafael Labegalini      
//
// Revisão: Júlio Xavier Vianna Neto
//
//
// Versão: 2.0
//
// Referência: L. Fingersh, M. Hand, A.Laxson
//             "Wind Turbine Design Cost and Scaling Model", 2006 
//
//

clc
xdel(winsid()) //Equivalente de close all
clear

//
//                  //**//  VARIÁVEIS INICIAIS  \\**\\
raio_rotor = 54/2;
diametro_rotor = raio_rotor*2;
machine_rating = 900;
torque_eixo = 370;
altura_hub = 75;
AEP = 1.581e6;
vida_util = 20;
fator_correcao_massa = 1;
fator_correcao_custo = 1.15;
fator_correcao_gerador = 3/2.38;

//                  //**//  ÍNDICES ECONÔMICOS  \\**\\
//
// Taxa cambial de dólar para real em 30/12/2011
USD_ind = 1.8751;

// General inflation escalation based on the Gross Domestic Product (GDP) -
// from 2002 to 2011
GDP_ind = 13299.1/11543.1;

// Component escalation by Producer Price Indexes (PPIs) - from 09/2002 to
// 01/2012
NAICS_327212 = 84.5/101.7;
NAICS_325520 = 249.3/157.3;
NAICS_332722 = 109.0/98.6;
NAICS_326150P = 141.4/100.0;  //Somente apresenta dados a partir de 12/2003
NAICS_3315113 = 174.4/113.1;
NAICS_332991P = 239.6/169.2;
NAICS_3353123 = 246.3/149.6;
NAICS_333612P = 241.4/165.2;
NAICS_334513 = 202.6/157.1;
NAICS_3315131 = 234.6/142.9;
NAICS_3363401 = 113.6/106.7;
NAICS_335312P = 200.0/139.9;
NAICS_335314P = 202.2/147.4;
NAICS_335313P = 199.8/150.4;
NAICS_3359291 = 240.2/108.6;
NAICS_333995 = 173.3/122.4;
NAICS_331221 = 205.0/117.6;
NAICS_BCON = 212.1/138.9;
NAICS_4841212 = 140.7/109.9;
NAICS_335311 = 203.0/98.2;

//
//
//
////              --------------------------------------
//               //-----// MODELAGEM DE PESO \\-----\\
//               --------------------------------------
//
//
//                        //**//  PÁS  \\**\\
//
// Baseado no design de fibra de vidro das pás da LM:
  massa_total_pa=0.4948*raio_rotor^2.53*fator_correcao_massa   //para cada pá
//  massa_total_pa=1.0305*raio_rotor^2.3233*fator_correcao_massa   //para cada pá
//
//                        //**//  HUB  \\**\\
// Massa do Hub:
  massa_hub=(0.954*massa_total_pa+5680.3)*fator_correcao_massa
//
//                 //**//  PITCH E ROLAMENTOS  \\**\\
//
// Massa do Rolamento do Pitch (considerando massa total das 3 pás):
  massa_rolamento_pitch=(0.1295*massa_total_pa*3+491.31)*fator_correcao_massa
// Massa do Sistema de Pitch:
  massa_sistema_pitch=(massa_rolamento_pitch*1.328+555)*fator_correcao_massa
//
//                     //**//  NOSE CONE  \\**\\
//
// Massa do nose cone:
  massa_nose_cone=(18.5*diametro_rotor-520.5)*fator_correcao_massa
//
//                     //**//  EIXO ROTOR  \\**\\ 
//
// Massa do eixo do rotor (Low-Speed Shaft):
  massa_eixo=0.0142*diametro_rotor^2.888*fator_correcao_massa
//
//                //**//  ROLAMENTOS PRINCIPAIS  \\**\\ 
//
// Massa dos rolamentos principais:
  massa_rolamento=(diametro_rotor*8/600-0.033)*0.0092*diametro_rotor^2.5*fator_correcao_massa
//
//                //**//  CAIXA DE TRANSMISSÃO  \\**\\ 
//
// Devido a escolha de um projeto de aerogerador Direct-Drive, não há caixa
// de transmissão.
//
//      //**//  FREIO MECÂNICO, ACOPLAMENTO DE ALTA VELOCIDADE \\**\\
//              //**//  E COMPONENTES ASSOCIADOS \\**\\
//
// Massa do Freio/Acoplamento:
  custo_freio=1.9894*machine_rating-0.1141;
  massa_freio=custo_freio/10*fator_correcao_massa
//
//                       //**//  GERADOR  \\**\\ 
//
// Massa do gerador (direct-drive):
  massa_gerador=661.25*torque_eixo^0.606*fator_correcao_massa*fator_correcao_gerador
//
//                     //**//  ELETRÔNICA  \\**\\ 
//
// Desconsidera-se o peso desses componentes (em relação a massa total do
// aerogerador.
//
//          //**//  SISTEMA DE YAW E ROLAMENTOS ASSOCIADOS  \\**\\ 
//
// Massa do sistema yaw e rolamentos associados:
  massa_yaw=1.6*(0.0009*diametro_rotor^3.314)*fator_correcao_massa
//
//                     //**//  MAINFRAME  \\**\\ 
//
// Massa do mainframe (estrutura principal para direct-drive):
  massa_mainframe=1.228*diametro_rotor^1.953*fator_correcao_massa
// Massa da plataforma e trilhos:
  massa_plataforma=0.125*massa_mainframe*fator_correcao_massa
//
//                 //**//  CONEXÃO ELÉTRICA  \\**\\ 
//
// Conexão elétrica não é considerado o peso dos componentes
//
//          //**//  SISTEMA HIDRÁULICO E REFRIGERAÇÃO  \\**\\ 
//
// Massa do sistema hidráulico e de refrigeração:
  massa_hidraulico=0.08*machine_rating*fator_correcao_massa
//
//                    //**//  CARENAGEM NACELE  \\**\\ 
//
// Massa da carenagem da nacele:
  custo_nacele=11.537*machine_rating+3849.7;
  massa_nacele=custo_nacele/10*fator_correcao_massa
//
//             //**//  SISTEMA DE CONTROLE, SEGURANÇA  \\**\\ 
//              //**//  E MONITORAMENTO DE CONDIÇÕES  \\**\\ 
//
// O peso é desconsiderado nessa abordagem.
//
//                          //**//  TORRE  \\**\\  
//
// A massa da torre, considerada tubular de aço, para esta abordagem é dada
// por:
  area_varrida = %pi*raio_rotor^2;
  massa_torre=(0.3973*area_varrida*altura_hub-1414)*fator_correcao_massa
//
//                        //**//  FUNDAÇÃO  \\**\\  
//
// A massa da fundação não será considerada na abordagem, pois seu custo
// está mais relacionado à parâmetros como altura do hub e área varrida pelo
// aerogerador.

massa_total_rotor = massa_total_pa*3 + massa_hub + massa_sistema_pitch + massa_nose_cone

massa_total_nacele = massa_eixo + massa_rolamento + massa_freio + massa_gerador + massa_yaw + massa_mainframe + massa_plataforma + massa_hidraulico + massa_nacele


////              ---------------------------------------
//               //-----// MODELAGEM DE CUSTOS \\-----\\
//               ---------------------------------------
//
//
//                       //**//  PÁS  \\**\\
//
// Component cost escalation
  pa_cost_ind = 0.61*NAICS_327212 + 0.27*NAICS_325520 + 0.03*NAICS_332722 + 0.09*NAICS_326150P;
  
// Baseado no design de fibra de vidro das pás da LM:
  custo_pa=((0.4019*raio_rotor^3-955.24)*pa_cost_ind+2.7445*raio_rotor^2.5025*GDP_ind)/(1-0.28)*USD_ind*fator_correcao_custo
//
//                        //**//  HUB  \\**\\
//
// Component cost escalation
  hub_cost_ind = NAICS_3315113;
  
// Custo do Hub:
  custo_hub=massa_hub*4.25*hub_cost_ind*USD_ind*fator_correcao_custo
//
//                 //**//  PITCH E ROLAMENTOS  \\**\\
//
// Component cost escalation
  pitch_cost_ind = 0.5*NAICS_332991P + 0.2*NAICS_3353123 + 0.2*NAICS_333612P + 0.1*NAICS_334513;
  
// Custo do sistema de pitch (considerando as três pás):
  custo_sistema_pitch=2.28*(0.2106*diametro_rotor^2.6578)*pitch_cost_ind*USD_ind*fator_correcao_custo
//
//                     //**//  NOSE CONE  \\**\\
//
// Component cost escalation
  nose_cone_cost_ind = 0.55*NAICS_327212 + 0.3*NAICS_325520 + 0.15*GDP_ind;
  
// Custo do nose cone:
  custo_nose_cone=massa_nose_cone*5.57*nose_cone_cost_ind*USD_ind*fator_correcao_custo
//
//                     //**//  EIXO ROTOR  \\**\\ 
//
// Component cost escalation
  eixo_cost_ind = NAICS_3315131;
  
// Custo do eixo do rotor (Low-Speed Shaft):
  custo_eixo=0.01*diametro_rotor^2.887*eixo_cost_ind*USD_ind*fator_correcao_custo
//
//                //**//  ROLAMENTOS PRINCIPAIS  \\**\\ 
//
// Component cost escalation
  rolamento_cost_ind = NAICS_332991P;
  
// Custo dos rolamentos principais:
  custo_rolamento=2*massa_rolamento*17.6*rolamento_cost_ind*USD_ind*fator_correcao_custo
//
//                //**//  CAIXA DE TRANSMISSÃO  \\**\\ 
//
// Devido a escolha de um projeto de aerogerador Direct-Drive, não há caixa
// de transmissão.
//
//      //**//  FREIO MECÂNICO, ACOPLAMENTO DE ALTA VELOCIDADE \\**\\
//              //**//  E COMPONENTES ASSOCIADOS \\**\\
//
// Component cost escalation
  freio_cost_ind = NAICS_3363401;
  
// Custo do freio/acoplamento:
  custo_freio=(1.9894*machine_rating-0.1141)*freio_cost_ind*USD_ind*fator_correcao_custo
//
//                     //**//  GERADOR  \\**\\ 
//
// Component cost escalation
  gerador_cost_ind = NAICS_335312P;
  
// Custo do gerador (direct-drive):
  custo_gerador=machine_rating*219.33*gerador_cost_ind*USD_ind*fator_correcao_custo*fator_correcao_gerador
//
//                    //**//  ELETRÔNICA  \\**\\ 
//
// Component cost escalation
  eletronico_cost_ind = NAICS_335314P;
  
// Custo dos componentes eletrônicos de velocidade variável:
  custo_eletronico=machine_rating*79*eletronico_cost_ind*USD_ind*fator_correcao_custo
//
//       //**//  SISTEMA DE YAW E ROLAMENTOS ASSOCIADOS  \\**\\ 
//
// Component cost escalation
  yaw_cost_ind = 0.5*NAICS_3353123 + 0.5*NAICS_332991P;
  
// Custo de sistema de yaw e rolamentos associados:
  custo_yaw=2*(0.0339*diametro_rotor^2.964)*yaw_cost_ind*USD_ind*fator_correcao_custo
//
//                     //**//  MAINFRAME  \\**\\ 
//
// Component cost escalation
  mainframe_cost_ind = NAICS_3315113;
  
// Custo do mainframe (estrutura principal para direct-drive):
  custo_mainframe=627.28*diametro_rotor^0.85*mainframe_cost_ind*USD_ind*fator_correcao_custo
// Custo das plataformas e trilhos:
  custo_plataforma=massa_plataforma*8.7*mainframe_cost_ind*USD_ind*fator_correcao_custo
//
//                  //**//  CONEXÃO ELÉTRICA  \\**\\ 
//
// Component cost escalation
  condutores_cost_ind = 0.25*NAICS_335313P + 0.6*NAICS_3359291 + 0.15*GDP_ind;
  
// Custo da conexão elétrica:
  custo_condutores=machine_rating*40*condutores_cost_ind*USD_ind*fator_correcao_custo
//
//            //**//  SISTEMA HIDRÁULICO E REFRIGERAÇÃO  \\**\\ 
//
// Component cost escalation
  hidraulico_cost_ind = NAICS_333995;
  
// Custo do sistema hidráulico e de refrigeração:
  custo_hidraulico=machine_rating*12*hidraulico_cost_ind*USD_ind*fator_correcao_custo
//
//                     //**//  CARENAGEM NACELE  \\**\\ 
//
// Component cost escalation
  nacele_cost_ind = 0.55*NAICS_327212 + 0.3*NAICS_325520 + 0.15*GDP_ind;
  
// Custo da carenagem da nacele:
  custo_nacele=(11.537*machine_rating+3849.7)*nacele_cost_ind*USD_ind*fator_correcao_custo
//
//               //**//  SISTEMA DE CONTROLE, SEGURANÇA  \\**\\ 
//                //**//  E MONITORAMENTO DE CONDIÇÕES  \\**\\ 
//
// Component cost escalation
  controle_cost_ind = NAICS_334513;
  
// O custo dos sistema de controle, segurança e condições de monitoramento
// são considerados de forma generalizada e como sem alteração para
// aerogeradores de diferentes tamanhos:
  custo_controle=35000*controle_cost_ind*USD_ind*fator_correcao_custo
//
//                       //**//  TORRE  \\**\\  
//
// Component cost escalation
  torre_cost_ind = NAICS_331221;
  
// O custo da torre, considerada tubular de aço, para esta abordagem é dada
// por:
  custo_torre=massa_torre*1.50*torre_cost_ind*USD_ind*fator_correcao_custo
//
//                      //**//  FUNDAÇÃO \\**\\  
//
// Component cost escalation
  fundacao_cost_ind = NAICS_BCON;
  
// A massa da torre, considerada tubular de aço, para esta abordagem é dada
// por:
  custo_fundacao=303.24*(altura_hub*area_varrida)^0.4037*fundacao_cost_ind*USD_ind*fator_correcao_custo
//
//                      //**//  TRANSPORTE  \\**\\  
//
// Component cost escalation
  transporte_cost_ind = NAICS_4841212;
  
// O custo generalizado com a parte logística da instalação de um
// aerogerador é dado pela formula abaixo:
  fator_custo_transporte=1.581e-5*machine_rating^2-0.0375*machine_rating+54.7;
  custo_transporte=machine_rating*fator_custo_transporte*transporte_cost_ind*USD_ind*fator_correcao_custo
//
//                      //**//  RODOVIAS  \\**\\  
//
// Component cost escalation
  rodovia_cost_ind = NAICS_BCON;
  
// Os custos com logística também incluem o valor estimado para o trabalho
// civil e rodovias para acesso. Esse estudo estima um valor médio para
// modificações em estradas para a passagem de grandes máquinas:
  fator_custo_rodovia=2.17e-6*machine_rating^2-0.0145*machine_rating+69.54;
  custo_rodovia=machine_rating*fator_custo_rodovia*rodovia_cost_ind*USD_ind*fator_correcao_custo
//
//                 //**//  MONTAGEM E INSTALAÇÃO  \\**\\  
//
// Component cost escalation
  montagem_cost_ind = NAICS_BCON;
  
// O custo de montagem e instalação são dados em função da altura do hub e
// diâmetro do rotor:
  custo_montagem=1.965*(altura_hub*diametro_rotor)^1.1736*montagem_cost_ind*USD_ind*fator_correcao_custo
//
//                   //**//  CONEXÃO À REDE  \\**\\  
//
// Component cost escalation
  conexao_cost_ind = 0.4*NAICS_335311 + 0.15*NAICS_335313P + 0.35*NAICS_3359291 + 0.1*GDP_ind;
  
// O custo de conexão à rede elétrica é dado por:
  fator_custo_conexao=3.49e-6*machine_rating^2-0.0221*machine_rating+109.7;
  custo_conexao=machine_rating*fator_custo_conexao*conexao_cost_ind*USD_ind*fator_correcao_custo
//
//              //**//  ENGENHARIA E AUTORIZAÇÕES  \\**\\  
//
// O custo de engenharia e permissões cobrem o custo de projeto e permissões
// de instalação de aerogeradores em parques eólicos:
  fator_custo_engenharia=9.94e-4*machine_rating+20.31;
  custo_engenharia=machine_rating*fator_custo_engenharia*GDP_ind*USD_ind*fator_correcao_custo
//
//                //**//  CUSTOS DE REPOSIÇÃO  \\**\\  
//
// Os custos de reposição a longo prazo são dados por:
  fator_custo_reposicao=10.7;
  custo_anual_reposicao=machine_rating*fator_custo_reposicao*GDP_ind*USD_ind*fator_correcao_custo
//
//               //**//  OPERAÇÃO E MANUTENÇÃO  \\**\\  
//
// Os custos de operação e manutenção:
  custo_manutencao=0.007*AEP*GDP_ind*USD_ind*fator_correcao_custo
  custo_manutencao_30MW=custo_manutencao/machine_rating*30e3
  //custo_manutencao = 75000
//
//       //**//  CUSTOS DE LOCAÇÃO DO PARQUE EÓLICO  \\**\\  
//
// Os custos de locação do parque eólico:
  custo_locacao=0.00108*AEP*GDP_ind*USD_ind*fator_correcao_custo

custo_maquina = custo_pa*3 + custo_hub + custo_sistema_pitch + custo_nose_cone + custo_eixo + custo_rolamento + ...
    custo_freio + custo_gerador + custo_eletronico + custo_yaw + custo_mainframe + custo_plataforma + custo_condutores + ...
    custo_hidraulico + custo_nacele + custo_controle + custo_torre

custo_total_instalacao = custo_maquina + custo_fundacao + custo_transporte + custo_rodovia + custo_montagem + custo_conexao + custo_engenharia

custo_total = custo_total_instalacao + (custo_anual_reposicao + custo_manutencao + custo_locacao)*vida_util

custo_MW_maquina = custo_maquina/machine_rating*1000

custo_MW_instalado = custo_total_instalacao/machine_rating*1000

perc_custo_pas = custo_pa*3/custo_total_instalacao*100
perc_custo_hub = custo_hub/custo_total_instalacao*100
perc_custo_sistema_pitch = custo_sistema_pitch/custo_total_instalacao*100
perc_custo_nose_cone = custo_nose_cone/custo_total_instalacao*100
perc_custo_eixo = custo_eixo/custo_total_instalacao*100
perc_custo_rolamento = custo_rolamento/custo_total_instalacao*100
perc_custo_freio= custo_freio/custo_total_instalacao*100
perc_custo_gerador = custo_gerador/custo_total_instalacao*100
perc_custo_eletronico = custo_eletronico/custo_total_instalacao*100
perc_custo_yaw = custo_yaw/custo_total_instalacao*100
perc_custo_mainframe = custo_mainframe/custo_total_instalacao*100
perc_custo_plataforma = custo_plataforma/custo_total_instalacao*100
perc_custo_condutores = custo_condutores/custo_total_instalacao*100
perc_custo_hidraulico = custo_hidraulico/custo_total_instalacao*100
perc_custo_nacele = custo_nacele/custo_total_instalacao*100
perc_custo_controle = custo_controle/custo_total_instalacao*100
perc_custo_torre = custo_torre/custo_total_instalacao*100
perc_custo_fundacao = custo_fundacao/custo_total_instalacao*100
perc_custo_transporte = custo_transporte/custo_total_instalacao*100
perc_custo_rodovia = custo_rodovia/custo_total_instalacao*100
perc_custo_montagem = custo_montagem/custo_total_instalacao*100
perc_custo_conexao = custo_conexao/custo_total_instalacao*100
perc_custo_engenharia = custo_engenharia/custo_total_instalacao*100
//perc_custo_reposicao = custo_anual_reposicao*vida_util/custo_total_instalacao*100
//perc_custo_manutencao = custo_manutencao*vida_util/custo_total_instalacao*100
//perc_custo_locacao = custo_locacao*vida_util/custo_total_instalacao*100

tabela = [  '3 Pas'                                           string(perc_custo_pas/100)                                 string(custo_pa*3)
            'Hub'                                             string(perc_custo_hub/100)                                 string(custo_hub)
            'Carenagem do hub'                                string(perc_custo_nose_cone/100)                           string(custo_nose_cone)
            'Eixo principal'                                  string(perc_custo_eixo/100)                                string(custo_eixo)
            'Rolamento do gerador'                            string(perc_custo_rolamento/100)                           string(custo_rolamento)
            'Gerador'                                         string(perc_custo_gerador/100)                             string(custo_gerador)
            'Freio do rotor e acoplamentos'                   string(perc_custo_freio/100)                               string(custo_freio)
            'Sistema de yaw'                                  string(perc_custo_yaw/100)                                 string(custo_yaw)
            'Sistemas hidraulicos e de refrigeracao'          string(perc_custo_hidraulico/100)                          string(custo_hidraulico)
            'Armacao principal'                               string(perc_custo_mainframe/100+perc_custo_plataforma/100) string(custo_mainframe+custo_plataforma)
            'Carenagem da nacele'                             string(perc_custo_nacele/100)                              string(custo_nacele)
            'Conexoes eletricas'                              string(perc_custo_condutores/100)                          string(custo_condutores)
            'Sistemas de pitch'                               string(perc_custo_sistema_pitch/100)                       string(custo_sistema_pitch)
            'Eletronica de potencia'                          string(perc_custo_eletronico/100)                          string(custo_eletronico)
            'Sistemas de controle, seguranca e monitoramento' string(perc_custo_controle/100)                            string(custo_controle)
            'Torre'                                           string(perc_custo_torre/100)                               string(custo_torre)
            'Fundacao'                                        string(perc_custo_fundacao/100)                            string(custo_fundacao)
            'Vias de acesso e obras civis'                    string(perc_custo_rodovia/100)                             string(custo_rodovia)
            'Transporte'                                      string(perc_custo_transporte/100)                          string(custo_transporte)
            'Montagem e instalacao'                           string(perc_custo_montagem/100)                            string(custo_montagem)
            'Conexao com a rede eletrica'                     string(perc_custo_conexao/100)                             string(custo_conexao)
            'Engenharia e licenciamento'                      string(perc_custo_engenharia/100)                          string(custo_engenharia)]; 

csvWrite(tabela,'Composicao_de_custos.xls',ascii(9),',');

// Custos relativos somente à turbina
perc_custo_pas = custo_pa*3/custo_maquina*100
perc_custo_hub = (custo_hub+custo_nose_cone)/custo_maquina*100
perc_custo_eixo = custo_eixo/custo_maquina*100
perc_custo_gerador = (custo_gerador+custo_rolamento)/custo_maquina*100
perc_custo_freio= custo_freio/custo_maquina*100
perc_custo_yaw = custo_yaw/custo_maquina*100
perc_custo_hidraulico = custo_hidraulico/custo_maquina*100
perc_custo_mainframe = (custo_mainframe+custo_plataforma)/custo_maquina*100
perc_custo_nacele = custo_nacele/custo_maquina*100
perc_custo_condutores = custo_condutores/custo_maquina*100
perc_custo_sistema_pitch = custo_sistema_pitch/custo_maquina*100
perc_custo_eletronico = custo_eletronico/custo_maquina*100
perc_custo_controle = custo_controle/custo_maquina*100
perc_custo_torre = custo_torre/custo_maquina*100

total = perc_custo_pas+perc_custo_hub+perc_custo_eixo+perc_custo_gerador+perc_custo_freio+perc_custo_yaw+...
    perc_custo_hidraulico+perc_custo_mainframe+perc_custo_nacele+perc_custo_condutores+perc_custo_sistema_pitch+...
    perc_custo_eletronico+perc_custo_controle+perc_custo_torre
