function [custo_MW_instalado] = get_custos_implantacao(parametros,verbose,arquivo_xls)
//   ------------------------------------------------------------------
//   //-----//-----//   MODELAGEM DE MASSAS E CUSTOS   \\-----\\-----\\
//   ------------------------------------------------------------------
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


//                  //**//  VARIÁVEIS INICIAIS  \\**\\
//
// Raio do rotor (m)
raio_rotor = parametros.diametro_rotor/2;

// Fator multiplicativo de massa, para contabilizar a redução de massa dos
// componentes causada pela evolução da tecnologia
if ~isfield(parametros,'fator_correcao_massa') then
    parametros.fator_correcao_massa = 1;
end

// Fator multiplicativo de custo, para contabilizar as diferenças entre EUA e Brasil
if ~isfield(parametros,'fator_correcao_custo') then
    parametros.fator_correcao_custo = 1.15;
end

// Fator multiplicativo de massa e custo do gerador, para contabilizar o
// aumento de massa no caso de gerador síncrono direct drive com rotor bobinado
if ~isfield(parametros,'fator_correcao_gerador') then
    parametros.fator_correcao_gerador = 1;
end

// Projeto da torre [1-Baseline; 2-Advanced]
if ~isfield(parametros,'projeto_torre') then
    parametros.projeto_torre = 1;
end

// Cálculo do máximo torque aerodinâmico no eixo do rotor (kNm)
if parametros.modelo_torque == 1 then
    parametros.torque_eixo = parametros.potencia_nominal/(parametros.eficiencia*parametros.rotacao_nominal/60*2*%pi);
end

//AEP = 1.581e6;
//vida_util = 20;


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
//               ---------------------------------------------
//               //-----// MODELO DE MASSAS E CUSTOS \\-----\\
//               ---------------------------------------------
//
//
//                        //**//  PÁS  \\**\\
//
// Component cost escalation
  pa_cost_ind = 0.61*NAICS_327212 + 0.27*NAICS_325520 + 0.03*NAICS_332722 + 0.09*NAICS_326150P;
  
  if raio_rotor < 45 then   //Baseline
      // Massa da pá:
      massa_total_pa=0.1452*raio_rotor^2.9158*parametros.fator_correcao_massa   //para cada pá
      // Custo da pá:
      custo_pa=((0.4019*raio_rotor^3-955.24)*pa_cost_ind+2.7445*raio_rotor^2.5025*GDP_ind)/(1-0.28)*USD_ind*parametros.fator_correcao_custo
      
  else  //Advanced - Baseado no design de fibra de vidro das pás da LM
      // Massa da pá:
      massa_total_pa=0.4948*raio_rotor^2.53*parametros.fator_correcao_massa   //para cada pá
      // Custo da pá:
      custo_pa=((0.4019*raio_rotor^3-21051)*pa_cost_ind+2.7445*raio_rotor^2.5025*GDP_ind)/(1-0.28)*USD_ind*parametros.fator_correcao_custo
  end
//
// Modelo calibrado pelo catálogo de pás da LM:
//  massa_total_pa=1.0305*raio_rotor^2.3233*parametros.fator_correcao_massa   //para cada pá
//
//                        //**//  HUB  \\**\\
// Massa do Hub:
  massa_hub=(0.954*massa_total_pa+5680.3)*parametros.fator_correcao_massa
//
// Component cost escalation
  hub_cost_ind = NAICS_3315113;
//
// Custo do Hub:
  custo_hub=massa_hub*4.25*hub_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//                 //**//  PITCH E ROLAMENTOS  \\**\\
//
// Massa do Rolamento do Pitch (considerando massa total das 3 pás):
  massa_rolamento_pitch=(0.1295*massa_total_pa*3+491.31)*parametros.fator_correcao_massa
// Massa do Sistema de Pitch:
  massa_sistema_pitch=(massa_rolamento_pitch*1.328+555)*parametros.fator_correcao_massa
//
// Component cost escalation
  pitch_cost_ind = 0.5*NAICS_332991P + 0.2*NAICS_3353123 + 0.2*NAICS_333612P + 0.1*NAICS_334513;
  
// Custo do sistema de pitch (considerando as três pás):
  custo_sistema_pitch=2.28*(0.2106*parametros.diametro_rotor^2.6578)*pitch_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//                     //**//  NOSE CONE  \\**\\
//
// Massa do nose cone:
  massa_nose_cone=(18.5*parametros.diametro_rotor-520.5)*parametros.fator_correcao_massa
//
// Component cost escalation
  nose_cone_cost_ind = 0.55*NAICS_327212 + 0.3*NAICS_325520 + 0.15*GDP_ind;
  
// Custo do nose cone:
  custo_nose_cone=massa_nose_cone*5.57*nose_cone_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//                     //**//  EIXO ROTOR  \\**\\ 
//
// Massa do eixo do rotor (Low-Speed Shaft):
  massa_eixo=0.0142*parametros.diametro_rotor^2.888*parametros.fator_correcao_massa
//
// Component cost escalation
  eixo_cost_ind = NAICS_3315131;
  
// Custo do eixo do rotor (Low-Speed Shaft):
  custo_eixo=0.01*parametros.diametro_rotor^2.887*eixo_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//                //**//  ROLAMENTOS PRINCIPAIS  \\**\\ 
//
// Massa dos rolamentos principais:
  massa_rolamento=(parametros.diametro_rotor*8/600-0.033)*0.0092*parametros.diametro_rotor^2.5*parametros.fator_correcao_massa
//
// Component cost escalation
  rolamento_cost_ind = NAICS_332991P;
  
// Custo dos rolamentos principais:
  custo_rolamento=2*massa_rolamento*17.6*rolamento_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//                //**//  CAIXA DE TRANSMISSÃO  \\**\\ 
//
// Component cost escalation
  gearbox_cost_ind = NAICS_333612P;

  select parametros.conceito
  case 1 //Three-Stage Drive with High-Speed Generator
      // Massa da caixa de transmissão:
      massa_gearbox = 70.94*parametros.torque_eixo^0.759*parametros.fator_correcao_massa
      // Custo da caixa de transmissão:
      custo_gearbox = 16.45*parametros.potencia_nominal^1.249*gearbox_cost_ind*USD_ind*parametros.fator_correcao_custo
      
  case 2 //Single-Stage Drive with Medium-Speed, Permanent-Magnet Generator
      // Massa da caixa de transmissão:
      massa_gearbox = 88.29*parametros.torque_eixo^0.774*parametros.fator_correcao_massa
      // Custo da caixa de transmissão:
      custo_gearbox = 74.1*parametros.potencia_nominal^1.00*gearbox_cost_ind*USD_ind*parametros.fator_correcao_custo
      
  case 3 //Multi-Path Drive with Multiple Permanent-Magnet Generators
      // Massa da caixa de transmissão:
      massa_gearbox = 139.69*parametros.torque_eixo^0.774*parametros.fator_correcao_massa
      // Custo da caixa de transmissão:
      custo_gearbox = 15.26*parametros.potencia_nominal^1.249*gearbox_cost_ind*USD_ind*parametros.fator_correcao_custo
      
  case 4 //Direct Drive
      // Massa da caixa de transmissão:
      massa_gearbox = 0
      // Custo da caixa de transmissão:
      custo_gearbox = 0
  end
//
//      //**//  FREIO MECÂNICO, ACOPLAMENTO DE ALTA VELOCIDADE \\**\\
//              //**//  E COMPONENTES ASSOCIADOS \\**\\
//
// Massa do Freio/Acoplamento:
  custo_freio=1.9894*parametros.potencia_nominal-0.1141;
  massa_freio=custo_freio/10*parametros.fator_correcao_massa
//
// Component cost escalation
  freio_cost_ind = NAICS_3363401;
  
// Custo do freio/acoplamento:
  custo_freio=(1.9894*parametros.potencia_nominal-0.1141)*freio_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//                       //**//  GERADOR  \\**\\ 
//
// Component cost escalation
  gerador_cost_ind = NAICS_335312P;

  select parametros.conceito
  case 1 //Three-Stage Drive with High-Speed Generator
      // Massa do gerador:
      massa_gerador=6.47*parametros.torque_eixo^0.9223*parametros.fator_correcao_massa*parametros.fator_correcao_gerador
      // Custo do gerador (direct-drive):
      custo_gerador=parametros.potencia_nominal*65*gerador_cost_ind*USD_ind*parametros.fator_correcao_custo*parametros.fator_correcao_gerador
      
  case 2 //Single-Stage Drive with Medium-Speed, Permanent-Magnet Generator
      // Massa do gerador:
      massa_gerador=10.51*parametros.torque_eixo^0.9223*parametros.fator_correcao_massa*parametros.fator_correcao_gerador
      // Custo do gerador (direct-drive):
      custo_gerador=parametros.potencia_nominal*54.73*gerador_cost_ind*USD_ind*parametros.fator_correcao_custo*parametros.fator_correcao_gerador
      
  case 3 //Multi-Path Drive with Multiple Permanent-Magnet Generators
      // Massa do gerador:
      massa_gerador=5.34*parametros.torque_eixo^0.9223*parametros.fator_correcao_massa*parametros.fator_correcao_gerador
      // Custo do gerador (direct-drive):
      custo_gerador=parametros.potencia_nominal*48.03*gerador_cost_ind*USD_ind*parametros.fator_correcao_custo*parametros.fator_correcao_gerador
      
  case 4 //Direct Drive
      // Massa do gerador:
      massa_gerador=661.25*parametros.torque_eixo^0.606*parametros.fator_correcao_massa*parametros.fator_correcao_gerador
      // Custo do gerador (direct-drive):
      custo_gerador=parametros.potencia_nominal*219.33*gerador_cost_ind*USD_ind*parametros.fator_correcao_custo*parametros.fator_correcao_gerador
  end
//
//                     //**//  ELETRÔNICA  \\**\\ 
//
// Desconsidera-se a massa desses componentes (em relação a massa total do
// aerogerador.
//
// Component cost escalation
  eletronico_cost_ind = NAICS_335314P;
  
// Custo dos componentes eletrônicos de velocidade variável:
  custo_eletronico=parametros.potencia_nominal*79*eletronico_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//          //**//  SISTEMA DE YAW E ROLAMENTOS ASSOCIADOS  \\**\\ 
//
// Massa do sistema yaw e rolamentos associados:
  massa_yaw=1.6*(0.0009*parametros.diametro_rotor^3.314)*parametros.fator_correcao_massa
//
// Component cost escalation
  yaw_cost_ind = 0.5*NAICS_3353123 + 0.5*NAICS_332991P;
  
// Custo de sistema de yaw e rolamentos associados:
  custo_yaw=2*(0.0339*parametros.diametro_rotor^2.964)*yaw_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//                     //**//  MAINFRAME  \\**\\ 
//
// Component cost escalation
  mainframe_cost_ind = NAICS_3315113;

  select parametros.conceito
  case 1 //Three-Stage Drive with High-Speed Generator
      // Massa do mainframe (estrutura principal):
      massa_mainframe= 2.233*parametros.diametro_rotor^1.953*parametros.fator_correcao_massa
      // Custo do mainframe (estrutura principal):
      custo_mainframe=9.489*parametros.diametro_rotor^1.953*mainframe_cost_ind*USD_ind*parametros.fator_correcao_custo
      
  case 2 //Single-Stage Drive with Medium-Speed, Permanent-Magnet Generator
      // Massa do mainframe (estrutura principal):
      massa_mainframe=1.295*parametros.diametro_rotor^1.953*parametros.fator_correcao_massa
      // Custo do mainframe (estrutura principal):
      custo_mainframe=303.96*parametros.diametro_rotor^1.067*mainframe_cost_ind*USD_ind*parametros.fator_correcao_custo
      
  case 3 //Multi-Path Drive with Multiple Permanent-Magnet Generators
      // Massa do mainframe (estrutura principal):
      massa_mainframe=1.721*parametros.diametro_rotor^1.953*parametros.fator_correcao_massa
      // Custo do mainframe (estrutura principal):
      custo_mainframe=17.92*parametros.diametro_rotor^1.672*mainframe_cost_ind*USD_ind*parametros.fator_correcao_custo
      
  case 4 //Direct Drive
      // Massa do mainframe (estrutura principal):
      massa_mainframe=1.228*parametros.diametro_rotor^1.953*parametros.fator_correcao_massa
      // Custo do mainframe (estrutura principal):
      custo_mainframe=627.28*parametros.diametro_rotor^0.85*mainframe_cost_ind*USD_ind*parametros.fator_correcao_custo
  end
//  
// Massa da plataforma e trilhos:
  massa_plataforma=0.125*massa_mainframe*parametros.fator_correcao_massa
//
// Custo das plataformas e trilhos:
  custo_plataforma=massa_plataforma*8.7*mainframe_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//                 //**//  CONEXÃO ELÉTRICA  \\**\\ 
//
// Conexão elétrica não é considerado o peso dos componentes
//
// Component cost escalation
  condutores_cost_ind = 0.25*NAICS_335313P + 0.6*NAICS_3359291 + 0.15*GDP_ind;
  
// Custo da conexão elétrica:
  custo_condutores=parametros.potencia_nominal*40*condutores_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//          //**//  SISTEMA HIDRÁULICO E REFRIGERAÇÃO  \\**\\ 
//
// Massa do sistema hidráulico e de refrigeração:
  massa_hidraulico=0.08*parametros.potencia_nominal*parametros.fator_correcao_massa
//
// Component cost escalation
  hidraulico_cost_ind = NAICS_333995;
  
// Custo do sistema hidráulico e de refrigeração:
  custo_hidraulico=parametros.potencia_nominal*12*hidraulico_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//                    //**//  CARENAGEM NACELE  \\**\\ 
//
// Massa da carenagem da nacele:
  custo_nacele=11.537*parametros.potencia_nominal+3849.7;
  massa_nacele=custo_nacele/10*parametros.fator_correcao_massa
//
// Component cost escalation
  nacele_cost_ind = 0.55*NAICS_327212 + 0.3*NAICS_325520 + 0.15*GDP_ind;
  
// Custo da carenagem da nacele:
  custo_nacele=(11.537*parametros.potencia_nominal+3849.7)*nacele_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//             //**//  SISTEMA DE CONTROLE, SEGURANÇA  \\**\\ 
//              //**//  E MONITORAMENTO DE CONDIÇÕES  \\**\\ 
//
// A massa é desconsiderado nessa abordagem.
//
// Component cost escalation
  controle_cost_ind = NAICS_334513;
  
// O custo dos sistema de controle, segurança e condições de monitoramento
// são considerados de forma generalizada e como sem alteração para
// aerogeradores de diferentes tamanhos:
  custo_controle=35000*controle_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//                          //**//  TORRE  \\**\\  
//
// Área varrida pelo rotor
  area_varrida = %pi*raio_rotor^2;
//
// Component cost escalation
  torre_cost_ind = NAICS_331221;
  
  if parametros.projeto_torre == 1 then   //Baseline
      // A massa da torre, considerada tubular de aço, para esta abordagem é dada por:
      massa_torre=(0.3973*area_varrida*parametros.altura_hub-1414)*parametros.fator_correcao_massa
      
  else  //Advanced
      // A massa da torre, considerada tubular de aço, para esta abordagem é dada por:
      massa_torre=(0.2694*area_varrida*parametros.altura_hub+1779)*parametros.fator_correcao_massa
  end
//
// O custo da torre, considerada tubular de aço, para esta abordagem é dada
// por:
  custo_torre=massa_torre*1.50*torre_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//
//            ----------------------------------------------
//            //-----// MODELAGEM DE CUSTOS DO BOP \\-----\\
//            ----------------------------------------------
//
//
//                        //**//  FUNDAÇÃO  \\**\\  
//
// A massa da fundação não será considerada na abordagem, pois seu custo
// está mais relacionado à parâmetros como altura do hub e área varrida pelo
// aerogerador.
//
// Component cost escalation
  fundacao_cost_ind = NAICS_BCON;
  
// A massa da torre, considerada tubular de aço, para esta abordagem é dada
// por:
  custo_fundacao=303.24*(parametros.altura_hub*area_varrida)^0.4037*fundacao_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//                      //**//  TRANSPORTE  \\**\\  
//
// Component cost escalation
  transporte_cost_ind = NAICS_4841212;
  
// O custo generalizado com a parte logística da instalação de um
// aerogerador é dado pela formula abaixo:
  fator_custo_transporte=1.581e-5*parametros.potencia_nominal^2-0.0375*parametros.potencia_nominal+54.7;
  custo_transporte=parametros.potencia_nominal*fator_custo_transporte*transporte_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//                      //**//  RODOVIAS  \\**\\  
//
// Component cost escalation
  rodovia_cost_ind = NAICS_BCON;
  
// Os custos com logística também incluem o valor estimado para o trabalho
// civil e rodovias para acesso. Esse estudo estima um valor médio para
// modificações em estradas para a passagem de grandes máquinas:
  fator_custo_rodovia=2.17e-6*parametros.potencia_nominal^2-0.0145*parametros.potencia_nominal+69.54;
  custo_rodovia=parametros.potencia_nominal*fator_custo_rodovia*rodovia_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//                 //**//  MONTAGEM E INSTALAÇÃO  \\**\\  
//
// Component cost escalation
  montagem_cost_ind = NAICS_BCON;
  
// O custo de montagem e instalação são dados em função da altura do hub e
// diâmetro do rotor:
  custo_montagem=1.965*(parametros.altura_hub*parametros.diametro_rotor)^1.1736*montagem_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//                   //**//  CONEXÃO À REDE  \\**\\  
//
// Component cost escalation
  conexao_cost_ind = 0.4*NAICS_335311 + 0.15*NAICS_335313P + 0.35*NAICS_3359291 + 0.1*GDP_ind;
  
// O custo de conexão à rede elétrica é dado por:
  fator_custo_conexao=3.49e-6*parametros.potencia_nominal^2-0.0221*parametros.potencia_nominal+109.7;
  custo_conexao=parametros.potencia_nominal*fator_custo_conexao*conexao_cost_ind*USD_ind*parametros.fator_correcao_custo
//
//              //**//  ENGENHARIA E AUTORIZAÇÕES  \\**\\  
//
// O custo de engenharia e permissões cobrem o custo de projeto e permissões
// de instalação de aerogeradores em parques eólicos:
  fator_custo_engenharia=9.94e-4*parametros.potencia_nominal+20.31;
  custo_engenharia=parametros.potencia_nominal*fator_custo_engenharia*GDP_ind*USD_ind*parametros.fator_correcao_custo
//
//
//            ----------------------------------------------------
//            //-----// MODELAGEM DE CUSTOS OPERACIONAIS \\-----\\
//            ----------------------------------------------------
//
//
//                //**//  CUSTOS DE REPOSIÇÃO  \\**\\  
//
// Os custos de reposição a longo prazo são dados por:
//  fator_custo_reposicao=10.7;
//  custo_anual_reposicao=parametros.potencia_nominal*fator_custo_reposicao*GDP_ind*USD_ind*parametros.fator_correcao_custo
//
//               //**//  OPERAÇÃO E MANUTENÇÃO  \\**\\  
//
// Os custos de operação e manutenção:
//  custo_manutencao=0.007*AEP*GDP_ind*USD_ind*parametros.fator_correcao_custo
//  custo_manutencao_30MW=custo_manutencao/parametros.potencia_nominal*30e3
  //custo_manutencao = 75000
//
//       //**//  CUSTOS DE LOCAÇÃO DO PARQUE EÓLICO  \\**\\  
//
// Os custos de locação do parque eólico:
//  custo_locacao=0.00108*AEP*GDP_ind*USD_ind*parametros.fator_correcao_custo



massa_total_rotor = massa_total_pa*3 + massa_hub + massa_sistema_pitch + massa_nose_cone

massa_total_nacele = massa_eixo + massa_rolamento + massa_gearbox + massa_freio + ...
    massa_gerador + massa_yaw + massa_mainframe + massa_plataforma + massa_hidraulico + massa_nacele

custo_maquina = custo_pa*3 + custo_hub + custo_sistema_pitch + custo_nose_cone + custo_eixo + custo_rolamento + custo_gearbox + ...
    custo_freio + custo_gerador + custo_eletronico + custo_yaw + custo_mainframe + custo_plataforma + custo_condutores + ...
    custo_hidraulico + custo_nacele + custo_controle + custo_torre

custo_total_instalacao = custo_maquina + custo_fundacao + custo_transporte + custo_rodovia + custo_montagem + custo_conexao + custo_engenharia

//custo_total = custo_total_instalacao + (custo_anual_reposicao + custo_manutencao + custo_locacao)*vida_util

//custo_MW_maquina = custo_maquina/parametros.potencia_nominal*1000

custo_MW_instalado = custo_total_instalacao/parametros.potencia_nominal*1000

//
//                 ------------------------------------
//                 //-----// ARQUIVO DE SAÍDA \\-----\\
//                 ------------------------------------
//
//
if verbose then
    tabela1 = [ custo_pa*3                          custo_pa*3/parametros.potencia_nominal*1000
                custo_hub                           custo_hub/parametros.potencia_nominal*1000
                custo_nose_cone                     custo_nose_cone/parametros.potencia_nominal*1000
                custo_eixo                          custo_eixo/parametros.potencia_nominal*1000
                custo_gearbox                       custo_gearbox/parametros.potencia_nominal*1000
                custo_rolamento                     custo_rolamento/parametros.potencia_nominal*1000
                custo_gerador                       custo_gerador/parametros.potencia_nominal*1000
                custo_freio                         custo_freio/parametros.potencia_nominal*1000
                custo_yaw                           custo_yaw/parametros.potencia_nominal*1000
                custo_hidraulico                    custo_hidraulico/parametros.potencia_nominal*1000
                custo_mainframe+custo_plataforma    (custo_mainframe+custo_plataforma)/parametros.potencia_nominal*1000
                custo_nacele                        custo_nacele/parametros.potencia_nominal*1000
                custo_condutores                    custo_condutores/parametros.potencia_nominal*1000
                custo_sistema_pitch                 custo_sistema_pitch/parametros.potencia_nominal*1000
                custo_eletronico                    custo_eletronico/parametros.potencia_nominal*1000
                custo_controle                      custo_controle/parametros.potencia_nominal*1000
                custo_torre                         custo_torre/parametros.potencia_nominal*1000];
    
    tabela2 = [ custo_fundacao                      custo_fundacao/parametros.potencia_nominal*1000
                custo_rodovia                       custo_rodovia/parametros.potencia_nominal*1000
                custo_transporte                    custo_transporte/parametros.potencia_nominal*1000
                custo_montagem                      custo_montagem/parametros.potencia_nominal*1000
                custo_conexao                       custo_conexao/parametros.potencia_nominal*1000
                custo_engenharia                    custo_engenharia/parametros.potencia_nominal*1000];
    
    xls_NewExcel();
    xls_Open(arquivo_xls);
    // set visible excel windows
    //xls_SetVisible(%t);
    xls_SelectWorksheet('Custos da Turbina (Modelo NREL)');
    xls_SetData("D4", tabela1);
    xls_SetData("D23", tabela2);
    xls_Save();
    xls_Close();
    xls_Quit();
end

endfunction
